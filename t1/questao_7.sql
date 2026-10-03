-- ----------------------------------------------------------------------------
-- TRIGGER 1 - CONTROLE DO FLUXO DE SITUACAO DO RELATORIO

-- ECA
-- EVENTO:
--   BEFORE UPDATE em Relatorio, para cada linha.

-- CONDICAO:
--   A regra e analisada quando:
--   receber uma atualização na tabela, além de mudar a sitaucao

-- ACOES:
--   1. Permitir somente as transicoes:
--        RASCUNHO -> AGUARDANDO_AVALIACAO
--        DEVOLVIDO_PARA_AJUSTE -> AGUARDANDO_AVALIACAO
--        AGUARDANDO_AVALIACAO -> APROVADO
--        AGUARDANDO_AVALIACAO -> DEVOLVIDO_PARA_AJUSTE

-- Decisoes de projeto:
--   A situacao funciona como uma maquina de estados.
-- ----------------------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_controle_fluxo_situacao;

DELIMITER $$

CREATE TRIGGER trg_controle_fluxo_situacao  
BEFORE UPDATE ON Relatorio 
FOR EACH ROW 
BEGIN 	
    IF NEW.situacao <> OLD.situacao THEN 	  
        IF NOT ( 			
            (OLD.situacao = 'RASCUNHO' AND NEW.situacao = 'AGUARDANDO_AVALIACAO') 				
            OR  			
            (OLD.situacao = 'DEVOLVIDO_PARA_AJUSTE' AND NEW.situacao = 'AGUARDANDO_AVALIACAO') 				
            OR  			
            (OLD.situacao = 'AGUARDANDO_AVALIACAO' AND NEW.situacao = 'APROVADO') 				
            OR  			
            (OLD.situacao = 'AGUARDANDO_AVALIACAO' AND NEW.situacao = 'DEVOLVIDO_PARA_AJUSTE') 		
        ) THEN 		    
            SIGNAL SQLSTATE '45000' 		  	
            SET MESSAGE_TEXT = 'Transicao de situacao invalida para o fluxo do relatorio.'; 	
        END IF;
    END IF;
END$$

DELIMITER ;

-- 1.1 (PASSA) RASCUNHO -> AGUARDANDO_AVALIACAO.
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO' WHERE id = 45;

-- 1.2 (FALHA) APROVADO -> RASCUNHO: estado final nao pode ser reaberto.
UPDATE Relatorio SET situacao = 'RASCUNHO' WHERE id = 1;

-- 1.3 (FALHA) RASCUNHO -> APROVADO: pula a avaliacao.
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id = 47;

-- 1.4 (PASSA) UPDATE que nao muda a situacao nao e barrado, mesmo APROVADO.
UPDATE Relatorio SET cargaHorariaTotal = cargaHorariaTotal + 1 WHERE id = 1;

-- 1.5 (PASSA, VARIAS LINHAS) tres rascunhos submetidos de uma vez.
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO' WHERE id IN (77, 83, 104);

-- 1.6 (FALHA, VARIAS LINHAS) 30 e 37 (AGUARDANDO) seriam validos, mas 47
-- (RASCUNHO -> APROVADO) nao: o comando e atomico, nenhuma das 3 linhas muda.
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id IN (30, 37, 47);
SELECT id, situacao FROM Relatorio WHERE id IN (30, 37, 47);  -- 30 e 37 seguem AGUARDANDO


-- ----------------------------------------------------------------------------
-- TRIGGER 2 - AUDITORIA AUTOMATICA DAS MUDANCAS DE SITUACAO
--
-- ECA
-- EVENTO:
--   AFTER UPDATE em Relatorio, para cada linha.
--
-- CONDICAO:
--   NEW.situacao <> OLD.situacao.
--
-- ACOES:
--   1. Nova situacao AGUARDANDO_AVALIACAO: insere em EventoAuditoria um evento
--      SUBMISSAO em nome do docente do relatorio.
--   2. Nova situacao APROVADO ou DEVOLVIDO_PARA_AJUSTE: insere APROVACAO ou
--      DEVOLUCAO em nome do coordenador do curso.
--
-- Decisoes de projeto:
--   AFTER porque o evento so deve ser gravado depois que a transicao foi
--   aceita pelo trigger 1 (BEFORE). 
-- ----------------------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_auditoria_mudanca_situacao;

DELIMITER $$

CREATE TRIGGER trg_auditoria_mudanca_situacao
AFTER UPDATE ON Relatorio
FOR EACH ROW
BEGIN
    DECLARE v_coord INT;

    IF NEW.situacao <> OLD.situacao THEN
        IF NEW.situacao = 'AGUARDANDO_AVALIACAO' THEN
            INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId)
            VALUES (NEW.id, 'SUBMISSAO', NEW.docenteId);
        ELSE
            SELECT MIN(coordenadorId) INTO v_coord
              FROM VinculoCoordenadorCurso WHERE cursoId = NEW.cursoId;

            IF NEW.situacao = 'APROVADO' THEN
                INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId)
                VALUES (NEW.id, 'APROVACAO', v_coord);
            ELSE
                INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, justificativa)
                VALUES (NEW.id, 'DEVOLUCAO', v_coord, 'Devolvido pelo coordenador para ajuste.');
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- TESTES DO TRIGGER 2 (continuacao da mesma execucao dos testes do trigger 1)
-- ----------------------------------------------------------------------------

-- 2.1 (PASSA) submissao gera evento SUBMISSAO do docente (relatorio 20).
UPDATE Relatorio SET situacao = 'AGUARDANDO_AVALIACAO' WHERE id = 20;
SELECT tipo, usuarioId FROM EventoAuditoria WHERE relatorioId = 20 ORDER BY id DESC LIMIT 1;

-- 2.2 (PASSA) aprovacao gera APROVACAO em nome do coordenador do curso 2.
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id = 10;
SELECT tipo, usuarioId FROM EventoAuditoria WHERE relatorioId = 10 ORDER BY id DESC LIMIT 1;

-- 2.3 (PASSA) devolucao gera DEVOLUCAO com justificativa.
UPDATE Relatorio SET situacao = 'DEVOLVIDO_PARA_AJUSTE' WHERE id = 13;
SELECT tipo, usuarioId, justificativa FROM EventoAuditoria WHERE relatorioId = 13 ORDER BY id DESC LIMIT 1;

-- 2.4 (PASSA) coordenador que tambem e docente (Paulo, relatorio 7): o evento
-- e gravado normalmente em nome do coordenador do curso.
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id = 7;
SELECT tipo, usuarioId FROM EventoAuditoria WHERE relatorioId = 7 ORDER BY id DESC LIMIT 1;

-- 2.5 (PASSA, VARIAS LINHAS) aprova 3 relatorios de uma vez: 3 eventos APROVACAO.
UPDATE Relatorio SET situacao = 'APROVADO' WHERE id IN (23, 66, 81);
SELECT relatorioId, tipo, usuarioId FROM EventoAuditoria
 WHERE relatorioId IN (23, 66, 81) AND tipo = 'APROVACAO';

-- 2.6 (PASSA) UPDATE sem mudar a situacao nao gera evento.
UPDATE Relatorio SET cargaHorariaTotal = cargaHorariaTotal + 1 WHERE id = 96;
SELECT COUNT(*) FROM EventoAuditoria WHERE relatorioId = 96 AND ocorridoEm > NOW() - INTERVAL 1 MINUTE;  -- 0
