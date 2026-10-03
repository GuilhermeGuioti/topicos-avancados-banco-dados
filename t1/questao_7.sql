-- ============================================================================
-- QUESTAO 7 - GATILHOS (TRIGGERS)
--
-- Como executar:  mysql --force -t rsha_teste < questao_7.sql
--   (--force segue adiante apos os erros ESPERADOS; cada teste diz se deve
--   PASSAR ou FALHAR). Rode DEPOIS de questao_6.sql: os testes do gatilho 2
--   dependem da regra de integridade 4 (justificativa de devolucao).
--
-- Observacoes gerais:
--   * Cada teste roda em START TRANSACTION ... ROLLBACK: a base volta ao estado
--     original (ela segue para o backup final) e os testes nao dependem de ids
--     fixos, apenas de consultas sobre os dados.
--   * Variaveis de sessao opcionais, lidas pelos gatilhos:
--       @avaliador_id   -> coordenador que esta avaliando (no sistema real, o
--                          usuario logado). Se NULL, usa-se o primeiro
--                          coordenador elegivel do curso no periodo.
--       @justificativa  -> texto da devolucao. Se NULL, usa-se um texto padrao.
--     Todos os testes que as definem as zeram ao final (SET ... := NULL).
-- ============================================================================


-- ----------------------------------------------------------------------------
-- GATILHO 1 - CONTROLE DO FLUXO DE SITUACAO DO RELATORIO  (BEFORE UPDATE)
--
-- ECA (Evento-Condicao-Acoes)
--
-- EVENTO:
--   BEFORE UPDATE em Relatorio, FOR EACH ROW.
--
-- CONDICAO:
--   A situacao esta mudando (NEW.situacao <> OLD.situacao). Alteracoes que nao
--   mexem na situacao (ex.: recalculo de cargaHorariaTotal) nao sao analisadas.
--
-- ACOES (qualquer violacao aborta o comando com SIGNAL SQLSTATE '45000'):
--   1. Aceitar somente as transicoes da maquina de estados:
--        RASCUNHO              -> AGUARDANDO_AVALIACAO
--        DEVOLVIDO_PARA_AJUSTE -> AGUARDANDO_AVALIACAO
--        AGUARDANDO_AVALIACAO  -> APROVADO
--        AGUARDANDO_AVALIACAO  -> DEVOLVIDO_PARA_AJUSTE
--   2. Para submeter (-> AGUARDANDO_AVALIACAO): o relatorio precisa ter pelo
--      menos um ItemAtividade.
--   3. Para avaliar (-> APROVADO ou DEVOLVIDO_PARA_AJUSTE): determinar o
--      avaliador (@avaliador_id, ou o menor coordenador do curso no periodo
--      do relatorio que nao seja o proprio docente) e exigir que ele exista,
--      coordene o curso NAQUELE periodo e nao seja o autor do relatorio
--      (impossibilidade de autoavaliacao, regra do contexto do sistema).
--
-- Decisoes de projeto:
--   * BEFORE porque a validacao tem de impedir a gravacao da linha; um AFTER
--     precisaria desfazer o que ja foi feito.
--   * A situacao e uma maquina de estados; estado final (APROVADO) nao reabre.
--   * A checagem de autoavaliacao e feita aqui (e nao so no gatilho 2) para que
--     o relatorio de um coordenador que tambem leciona (caso do Paulo) nunca
--     chegue a APROVADO sem outro coordenador avaliando.
--   * Quando nao ha avaliador elegivel (curso sem coordenador no periodo, ou o
--     unico coordenador e o proprio docente) o comando e recusado em vez de
--     gravar um evento de auditoria sem autor.
-- ----------------------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_controle_fluxo_situacao;

DELIMITER $$

CREATE TRIGGER trg_controle_fluxo_situacao
BEFORE UPDATE ON Relatorio
FOR EACH ROW
BEGIN
    DECLARE v_avaliador INT;
    DECLARE v_coordena  INT;

    IF NEW.situacao <> OLD.situacao THEN

        -- Acao 1: transicao permitida?
        IF NOT (
               (OLD.situacao = 'RASCUNHO'              AND NEW.situacao = 'AGUARDANDO_AVALIACAO')
            OR (OLD.situacao = 'DEVOLVIDO_PARA_AJUSTE' AND NEW.situacao = 'AGUARDANDO_AVALIACAO')
            OR (OLD.situacao = 'AGUARDANDO_AVALIACAO'  AND NEW.situacao = 'APROVADO')
            OR (OLD.situacao = 'AGUARDANDO_AVALIACAO'  AND NEW.situacao = 'DEVOLVIDO_PARA_AJUSTE')
        ) THEN
            SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = 'Transicao de situacao invalida para o fluxo do relatorio.';
        END IF;

        -- Acao 2: nao se submete relatorio sem itens.
        IF NEW.situacao = 'AGUARDANDO_AVALIACAO'
           AND NOT EXISTS (SELECT 1 FROM ItemAtividade WHERE relatorioId = NEW.id) THEN
            SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = 'Relatorio sem itens de atividade nao pode ser submetido.';
        END IF;

        -- Acao 3: avaliacao exige avaliador valido e diferente do docente.
        IF NEW.situacao IN ('APROVADO', 'DEVOLVIDO_PARA_AJUSTE') THEN
            SET v_avaliador = COALESCE(@avaliador_id,
                (SELECT MIN(coordenadorId) FROM VinculoCoordenadorCurso
                  WHERE cursoId = NEW.cursoId
                    AND periodoLetivoId = NEW.periodoLetivoId
                    AND coordenadorId <> NEW.docenteId));

            IF v_avaliador IS NULL THEN
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = 'Nao ha avaliador elegivel para este curso e periodo.';
            END IF;

            IF v_avaliador = NEW.docenteId THEN
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = 'Autoavaliacao proibida: o docente nao pode avaliar o proprio relatorio.';
            END IF;

            SELECT COUNT(*) INTO v_coordena FROM VinculoCoordenadorCurso
             WHERE coordenadorId = v_avaliador
               AND cursoId = NEW.cursoId
               AND periodoLetivoId = NEW.periodoLetivoId;
            IF v_coordena = 0 THEN
                SIGNAL SQLSTATE '45000'
                   SET MESSAGE_TEXT = 'O avaliador nao coordena este curso neste periodo.';
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

-- 1.1 (PASSA) RASCUNHO -> AGUARDANDO_AVALIACAO.
START TRANSACTION;
SET @r := (SELECT id FROM Relatorio WHERE situacao = 'RASCUNHO' ORDER BY id LIMIT 1);
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO' WHERE id = @r;
SELECT id, situacao FROM Relatorio WHERE id = @r;
ROLLBACK;

-- 1.2 (FALHA) APROVADO -> RASCUNHO: estado final nao pode ser reaberto.
START TRANSACTION;
UPDATE Relatorio SET situacao = 'RASCUNHO'
 WHERE id = (SELECT MIN(id) FROM (SELECT id FROM Relatorio WHERE situacao = 'APROVADO') t);
ROLLBACK;

-- 1.3 (FALHA) RASCUNHO -> APROVADO: pula a avaliacao.
START TRANSACTION;
UPDATE Relatorio SET situacao = 'APROVADO'
 WHERE id = (SELECT MIN(id) FROM (SELECT id FROM Relatorio WHERE situacao = 'RASCUNHO') t);
ROLLBACK;

-- 1.4 (PASSA) UPDATE que nao muda a situacao nao e barrado, mesmo em APROVADO.
START TRANSACTION;
UPDATE Relatorio SET cargaHorariaTotal = cargaHorariaTotal + 1
 WHERE id = (SELECT MIN(id) FROM (SELECT id FROM Relatorio WHERE situacao = 'APROVADO') t);
ROLLBACK;

-- 1.5 (FALHA) submeter relatorio sem itens: cria um relatorio novo (vinculo
-- docente-curso-periodo ainda sem relatorio) e tenta submeter.
START TRANSACTION;
INSERT INTO Relatorio (docenteId, cursoId, periodoLetivoId)
SELECT v.docenteId, v.cursoId, v.periodoLetivoId
  FROM VinculoDocenteCurso v
  LEFT JOIN Relatorio r ON r.docenteId = v.docenteId AND r.cursoId = v.cursoId
                       AND r.periodoLetivoId = v.periodoLetivoId
 WHERE r.id IS NULL
 ORDER BY v.id LIMIT 1;
SET @novo := LAST_INSERT_ID();
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO' WHERE id = @novo;
ROLLBACK;

-- 1.6 (FALHA) autoavaliacao: Paulo coordena e leciona Educacao Fisica e e o
-- unico coordenador do curso. Submete o relatorio dele (passa) e tenta aprovar
-- (nao ha outro avaliador elegivel).
START TRANSACTION;
SET @paulo := (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br');
SET @r := (SELECT MIN(id) FROM Relatorio
            WHERE docenteId = @paulo AND situacao IN ('RASCUNHO', 'AGUARDANDO_AVALIACAO'));
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO' WHERE id = @r AND situacao = 'RASCUNHO';
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id = @r;
ROLLBACK;

-- 1.7 (FALHA) autoavaliacao explicita: mesmo informando o proprio Paulo como
-- avaliador, o comando e recusado.
START TRANSACTION;
SET @paulo := (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br');
SET @r := (SELECT MIN(id) FROM Relatorio
            WHERE docenteId = @paulo AND situacao IN ('RASCUNHO', 'AGUARDANDO_AVALIACAO'));
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO' WHERE id = @r AND situacao = 'RASCUNHO';
SET @avaliador_id := @paulo;
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id = @r;
SET @avaliador_id := NULL;
ROLLBACK;

-- 1.8 (FALHA) avaliador que nao coordena o curso do relatorio: informa como
-- avaliador um coordenador de OUTRO curso.
START TRANSACTION;
SET @r := (SELECT MIN(id) FROM Relatorio WHERE situacao = 'AGUARDANDO_AVALIACAO'
              AND docenteId <> (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br'));
SET @avaliador_id := (SELECT MIN(v.coordenadorId) FROM VinculoCoordenadorCurso v, Relatorio r
                       WHERE r.id = @r AND v.cursoId <> r.cursoId AND v.coordenadorId <> r.docenteId
                         AND NOT EXISTS (SELECT 1 FROM VinculoCoordenadorCurso x
                                          WHERE x.coordenadorId = v.coordenadorId
                                            AND x.cursoId = r.cursoId AND x.periodoLetivoId = r.periodoLetivoId));
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id = @r;
SET @avaliador_id := NULL;
ROLLBACK;

-- 1.9 (PASSA, VARIAS LINHAS) tres rascunhos submetidos de uma vez.
START TRANSACTION;
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO'
 WHERE id IN (SELECT id FROM (SELECT id FROM Relatorio WHERE situacao = 'RASCUNHO' ORDER BY id LIMIT 3) t);
SELECT COUNT(*) AS submetidos_agora FROM Relatorio
 WHERE situacao = 'AGUARDANDO_AVALIACAO' AND atualizadoEm >= NOW(3) - INTERVAL 1 MINUTE;
ROLLBACK;

-- 1.10 (FALHA, VARIAS LINHAS) dois AGUARDANDO seriam validos, mas o RASCUNHO
-- (RASCUNHO -> APROVADO) nao: o comando e atomico, nenhuma das 3 linhas muda.
START TRANSACTION;
SET @a1 := (SELECT MIN(id) FROM Relatorio WHERE situacao = 'AGUARDANDO_AVALIACAO' AND docenteId <> (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br'));
SET @a2 := (SELECT MIN(id) FROM Relatorio WHERE situacao = 'AGUARDANDO_AVALIACAO' AND id > @a1 AND docenteId <> (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br'));
SET @rs := (SELECT MIN(id) FROM Relatorio WHERE situacao = 'RASCUNHO');
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id IN (@a1, @a2, @rs);
SELECT id, situacao FROM Relatorio WHERE id IN (@a1, @a2, @rs);  -- a1 e a2 seguem AGUARDANDO
ROLLBACK;


-- ----------------------------------------------------------------------------
-- GATILHO 2 - AUDITORIA AUTOMATICA DAS MUDANCAS DE SITUACAO  (AFTER UPDATE)
--
-- ECA
--
-- EVENTO:
--   AFTER UPDATE em Relatorio, FOR EACH ROW.
--
-- CONDICAO:
--   NEW.situacao <> OLD.situacao.
--
-- ACOES:
--   1. Nova situacao AGUARDANDO_AVALIACAO: inserir em EventoAuditoria um evento
--      SUBMISSAO em nome do docente (NEW.docenteId).
--   2. Nova situacao APROVADO: inserir APROVACAO em nome do avaliador.
--   3. Nova situacao DEVOLVIDO_PARA_AJUSTE: inserir DEVOLUCAO em nome do
--      avaliador, com a justificativa informada em @justificativa (ou um texto
--      padrao). O avaliador e @avaliador_id ou, se nulo, o menor coordenador do
--      curso NO PERIODO do relatorio diferente do docente (a mesma escolha do
--      gatilho 1, que ja validou que ele existe e pode avaliar).
--   4. Para o evento de APROVACAO e DEVOLUCAO, inserir tambem uma Notificacao ao
--      docente informando o resultado.
--
-- Decisoes de projeto:
--   * AFTER porque o evento so deve ser gravado depois que a transicao foi
--     aceita pelo gatilho 1 (BEFORE) e a linha foi efetivamente atualizada.
--   * Se a insercao do evento violar uma regra de integridade (ex.: justificativa
--     curta demais na regra 4), o erro propaga e o UPDATE inteiro e desfeito: a
--     situacao nunca muda sem o evento correspondente na trilha.
--   * O avaliador e resolvido por periodo (nao so por curso): coordenadores
--     mudam de um semestre para outro.
-- ----------------------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_auditoria_mudanca_situacao;

DELIMITER $$

CREATE TRIGGER trg_auditoria_mudanca_situacao
AFTER UPDATE ON Relatorio
FOR EACH ROW
BEGIN
    DECLARE v_avaliador INT;

    IF NEW.situacao <> OLD.situacao THEN
        IF NEW.situacao = 'AGUARDANDO_AVALIACAO' THEN
            INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId)
            VALUES (NEW.id, 'SUBMISSAO', NEW.docenteId);
        ELSEIF NEW.situacao IN ('APROVADO', 'DEVOLVIDO_PARA_AJUSTE') THEN
            SET v_avaliador = COALESCE(@avaliador_id,
                (SELECT MIN(coordenadorId) FROM VinculoCoordenadorCurso
                  WHERE cursoId = NEW.cursoId
                    AND periodoLetivoId = NEW.periodoLetivoId
                    AND coordenadorId <> NEW.docenteId));

            IF NEW.situacao = 'APROVADO' THEN
                INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId)
                VALUES (NEW.id, 'APROVACAO', v_avaliador);
                INSERT INTO Notificacao (usuarioId, relatorioId, mensagem)
                VALUES (NEW.docenteId, NEW.id, 'Relatório aprovado.');
            ELSE
                INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, justificativa)
                VALUES (NEW.id, 'DEVOLUCAO', v_avaliador,
                        COALESCE(@justificativa, 'Devolvido pelo coordenador para ajuste.'));
                INSERT INTO Notificacao (usuarioId, relatorioId, mensagem)
                VALUES (NEW.docenteId, NEW.id, 'Relatório devolvido para ajuste.');
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- TESTES DO GATILHO 2
-- ----------------------------------------------------------------------------

-- 2.1 (PASSA) submissao gera evento SUBMISSAO em nome do docente.
START TRANSACTION;
SET @r := (SELECT id FROM Relatorio WHERE situacao = 'RASCUNHO' ORDER BY id LIMIT 1);
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO' WHERE id = @r;
SELECT e.tipo, e.usuarioId, r.docenteId FROM EventoAuditoria e JOIN Relatorio r ON r.id = e.relatorioId
 WHERE e.relatorioId = @r ORDER BY e.id DESC LIMIT 1;
ROLLBACK;

-- 2.2 (PASSA) aprovacao gera APROVACAO em nome do coordenador do curso do
-- relatorio, no periodo dele, e uma notificacao ao docente.
START TRANSACTION;
SET @r := (SELECT MIN(id) FROM Relatorio WHERE situacao = 'AGUARDANDO_AVALIACAO'
              AND docenteId <> (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br'));
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id = @r;
SELECT e.tipo, e.usuarioId AS avaliador,
       (SELECT COUNT(*) FROM VinculoCoordenadorCurso v
         WHERE v.coordenadorId = e.usuarioId AND v.cursoId = r.cursoId
           AND v.periodoLetivoId = r.periodoLetivoId) AS coordena_curso_no_periodo
  FROM EventoAuditoria e JOIN Relatorio r ON r.id = e.relatorioId
 WHERE e.relatorioId = @r ORDER BY e.id DESC LIMIT 1;
SELECT mensagem FROM Notificacao WHERE relatorioId = @r ORDER BY id DESC LIMIT 1;
ROLLBACK;

-- 2.3 (PASSA) devolucao com justificativa informada pelo avaliador.
START TRANSACTION;
SET @r := (SELECT MIN(id) FROM Relatorio WHERE situacao = 'AGUARDANDO_AVALIACAO'
              AND docenteId <> (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br'));
SET @justificativa := 'Detalhar melhor as atividades de orientacao.';
UPDATE Relatorio SET situacao = 'DEVOLVIDO_PARA_AJUSTE' WHERE id = @r;
SET @justificativa := NULL;
SELECT tipo, usuarioId, justificativa FROM EventoAuditoria WHERE relatorioId = @r ORDER BY id DESC LIMIT 1;
ROLLBACK;

-- 2.4 (PASSA, VARIAS LINHAS) aprova 3 relatorios de uma vez: 3 eventos APROVACAO,
-- cada um com o coordenador do PROPRIO curso/periodo (avaliadores diferentes).
START TRANSACTION;
UPDATE Relatorio SET situacao = 'APROVADO'
 WHERE id IN (SELECT id FROM (SELECT id FROM Relatorio
                               WHERE situacao = 'AGUARDANDO_AVALIACAO'
                                 AND docenteId <> (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br')
                               ORDER BY id LIMIT 3) t);
SELECT e.relatorioId, e.tipo, e.usuarioId AS avaliador
  FROM EventoAuditoria e
 WHERE e.tipo = 'APROVACAO' AND e.ocorridoEm >= NOW(3) - INTERVAL 1 MINUTE
 ORDER BY e.id DESC LIMIT 3;
ROLLBACK;

-- 2.5 (PASSA) UPDATE sem mudar a situacao nao gera evento nem notificacao.
START TRANSACTION;
SET @r := (SELECT MIN(id) FROM Relatorio WHERE situacao = 'AGUARDANDO_AVALIACAO');
SET @antes := (SELECT COUNT(*) FROM EventoAuditoria);
UPDATE Relatorio SET cargaHorariaTotal = cargaHorariaTotal + 1 WHERE id = @r;
SELECT COUNT(*) - @antes AS eventos_novos FROM EventoAuditoria;  -- 0
ROLLBACK;

-- 2.6 (FALHA) devolucao com justificativa curta demais: o evento viola a regra
-- de integridade 4, o erro propaga e o UPDATE da situacao e desfeito.
START TRANSACTION;
SET @r := (SELECT MIN(id) FROM Relatorio WHERE situacao = 'AGUARDANDO_AVALIACAO'
              AND docenteId <> (SELECT id FROM Usuario WHERE email = 'paulo@baraodemaua.br'));
SET @justificativa := 'ok';
UPDATE Relatorio SET situacao = 'DEVOLVIDO_PARA_AJUSTE' WHERE id = @r;
SET @justificativa := NULL;
SELECT situacao FROM Relatorio WHERE id = @r;  -- segue AGUARDANDO_AVALIACAO
ROLLBACK;
