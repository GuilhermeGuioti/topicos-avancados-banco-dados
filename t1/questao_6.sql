-- ----------------------------------------------------------------------------
-- REGRA 1 - Faixa de horas de um item de atividade
--
-- Enunciado: um item de atividade (um dia/horário específico dentro de um
-- relatório) deve registrar entre 0,5 e 8 horas.
--
-- Decisão de projeto: a carga diária máxima de um docente é de 8h, então um
-- item acima disso indica erro de lançamento (ex.: confundir minutos com
-- horas, ou tentar embutir a carga de vários dias em um único item). O piso
-- de 0,5h evita registros "vazios" ou residuais que não justificam a
-- existência de um item de atividade.
-- ----------------------------------------------------------------------------
ALTER TABLE `ItemAtividade`
  ADD CONSTRAINT `chk_item_horas_intervalo`
  CHECK (`horas` >= 0.5 AND `horas` <= 8);

-- Teste 1 (PASSA) - extremo inferior permitido (0,5h).
INSERT INTO `ItemAtividade` (relatorioId, tipoAtividadeId, horas, diaSemana, horario, descricao)
SELECT r.id, ta.id, 0.5, 'SEGUNDA', '07h-07h30', 'Teste regra 1 - limite inferior'
FROM `Relatorio` r, `TipoAtividade` ta
ORDER BY r.id, ta.id LIMIT 1;

-- Teste 2 (FALHA) - abaixo do mínimo (0,4h).
INSERT INTO `ItemAtividade` (relatorioId, tipoAtividadeId, horas, diaSemana, horario, descricao)
SELECT r.id, ta.id, 0.4, 'TERCA', '07h-07h24', 'Teste regra 1 - abaixo do minimo'
FROM `Relatorio` r, `TipoAtividade` ta
ORDER BY r.id, ta.id LIMIT 1;

-- Teste 3 (FALHA) - acima do máximo (8,5h, carga de mais de um dia num item só).
INSERT INTO `ItemAtividade` (relatorioId, tipoAtividadeId, horas, diaSemana, horario, descricao)
SELECT r.id, ta.id, 8.5, 'QUARTA', '07h-15h30', 'Teste regra 1 - acima do maximo'
FROM `Relatorio` r, `TipoAtividade` ta
ORDER BY r.id, ta.id LIMIT 1;

-- Teste 4 (PASSA) - extremo superior permitido (8h).
INSERT INTO `ItemAtividade` (relatorioId, tipoAtividadeId, horas, diaSemana, horario, descricao)
SELECT r.id, ta.id, 8.0, 'QUINTA', '07h-15h', 'Teste regra 1 - limite superior'
FROM `Relatorio` r, `TipoAtividade` ta
ORDER BY r.id, ta.id LIMIT 1;


-- ----------------------------------------------------------------------------
-- REGRA 2 - Coerência das datas de um período letivo
--
-- Enunciado: o encerramento da submissão de um período letivo deve ser
-- estritamente posterior à sua abertura.
--
-- Decisão de projeto: usamos ">" (e não ">=") porque uma janela de submissão
-- com abertura e encerramento no mesmo instante não tem utilidade prática -
-- ninguém conseguiria submeter nada. Isso também protege contra inversão
-- acidental das duas datas no cadastro de um novo período.
-- ----------------------------------------------------------------------------
ALTER TABLE `PeriodoLetivo`
  ADD CONSTRAINT `chk_periodo_datas_coerentes`
  CHECK (`encerramentoSubmissao` > `aberturaSubmissao`);

-- Teste 1 (FALHA) - abertura e encerramento no mesmo instante.
INSERT INTO `PeriodoLetivo` (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (1900, 1, '1900-02-01 08:00:00', '1900-02-01 08:00:00');

-- Teste 2 (FALHA) - encerramento antes da abertura (datas invertidas).
INSERT INTO `PeriodoLetivo` (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (1900, 1, '1900-07-10 00:00:00', '1900-02-01 00:00:00');

-- Teste 3 (PASSA) - encerramento um dia após a abertura.
INSERT INTO `PeriodoLetivo` (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (1900, 1, '1900-02-01 00:00:00', '1900-02-02 00:00:00');


-- ----------------------------------------------------------------------------
-- REGRA 3 - Teto plausível para a carga horária total de um relatório
--
-- Enunciado: a carga horária total consolidada de um relatório não pode ser
-- negativa nem ultrapassar 200 horas em um único período letivo.
--
-- Decisão de projeto: o valor não deveria nunca ficar negativo, pois é uma
-- soma de horas de itens de atividade; um valor negativo só chegaria à coluna
-- por bug de aplicação ou UPDATE manual incorreto. O teto de 200h é uma
-- salvaguarda de razoabilidade: mesmo em um semestre inteiro de atividades
-- extraclasse, um total acima disso é sinal quase certo de erro de
-- lançamento (ou de um item duplicado), não de dedicação real do docente.
-- ----------------------------------------------------------------------------
ALTER TABLE `Relatorio`
  ADD CONSTRAINT `chk_relatorio_carga_horaria_plausivel`
  CHECK (`cargaHorariaTotal` >= 0 AND `cargaHorariaTotal` <= 200);

-- Teste 1 (FALHA) - carga horária negativa.
UPDATE `Relatorio` SET cargaHorariaTotal = -5
WHERE id = (SELECT id FROM (SELECT MIN(id) AS id FROM `Relatorio`) t);

-- Teste 2 (FALHA) - carga horária acima do teto (300h).
UPDATE `Relatorio` SET cargaHorariaTotal = 300
WHERE id = (SELECT id FROM (SELECT MIN(id) AS id FROM `Relatorio`) t);

-- Teste 3 (PASSA) - carga horária dentro da faixa plausível (150h).
UPDATE `Relatorio` SET cargaHorariaTotal = 150
WHERE id = (SELECT id FROM (SELECT MIN(id) AS id FROM `Relatorio`) t);


-- ----------------------------------------------------------------------------
-- REGRA 4 - Justificativa obrigatória em devolução
--
-- Enunciado: todo evento de auditoria do tipo DEVOLUCAO deve ter uma
-- justificativa não nula e não vazia (ignorando espaços).
--
-- Decisão de projeto: a devolução é o único momento em que o coordenador
-- nega a submissão do docente, então ela precisa de motivação registrada -
-- sem isso, a trilha de auditoria não cumpriria o papel de substituir a
-- assinatura manuscrita mencionado no contexto do sistema. Usamos TRIM()
-- para barrar o "furo" óbvio de satisfazer um NOT NULL simples com uma
-- string só de espaços. A regra é condicional (só vale para DEVOLUCAO) para
-- não obrigar justificativa em CRIACAO, SUBMISSAO e APROVACAO, que não
-- precisam dela.
-- ----------------------------------------------------------------------------
ALTER TABLE `EventoAuditoria`
  ADD CONSTRAINT `chk_evento_devolucao_tem_justificativa`
  CHECK (`tipo` <> 'DEVOLUCAO' OR (`justificativa` IS NOT NULL AND TRIM(`justificativa`) <> ''));

-- Teste 1 (FALHA) - devolução sem justificativa (NULL).
INSERT INTO `EventoAuditoria` (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'DEVOLUCAO', u.id, NOW(3), NULL
FROM `Relatorio` r, `Usuario` u
ORDER BY r.id, u.id LIMIT 1;

-- Teste 2 (FALHA) - devolução com justificativa só de espaços em branco.
INSERT INTO `EventoAuditoria` (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'DEVOLUCAO', u.id, NOW(3), '    '
FROM `Relatorio` r, `Usuario` u
ORDER BY r.id, u.id LIMIT 1;

-- Teste 3 (PASSA) - devolução com justificativa válida.
INSERT INTO `EventoAuditoria` (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'DEVOLUCAO', u.id, NOW(3), 'Teste regra 4 - justificativa valida preenchida'
FROM `Relatorio` r, `Usuario` u
ORDER BY r.id, u.id LIMIT 1;

-- Teste 4 (PASSA) - aprovação sem justificativa (mostra que a regra é
-- condicional: só se aplica a DEVOLUCAO, não aos demais tipos de evento).
INSERT INTO `EventoAuditoria` (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'APROVACAO', u.id, NOW(3), NULL
FROM `Relatorio` r, `Usuario` u
ORDER BY r.id, u.id LIMIT 1;


-- ----------------------------------------------------------------------------
-- REGRA 5 - Formato mínimo do e-mail institucional
--
-- Enunciado: o e-mail de um usuário deve seguir o formato
-- "algo@dominio.tld" (usuário, arroba, domínio com pelo menos um ponto e um
-- sufixo de 2+ letras).
--
-- Decisão de projeto: como o login é delegado ao Microsoft Entra ID (sem
-- senha própria no SRHA), o e-mail é o identificador que amarra o usuário do
-- banco à identidade institucional - um valor mal formatado quebraria essa
-- amarração silenciosamente. Optamos por uma expressão regular simples
-- (REGEXP_LIKE, disponível desde o MySQL 8.0.4) em vez de uma validação
-- completa de RFC 5322, que seria complexa demais para o que a regra
-- realmente precisa garantir aqui.
-- ----------------------------------------------------------------------------
ALTER TABLE `Usuario`
  ADD CONSTRAINT `chk_usuario_email_formato`
  CHECK (REGEXP_LIKE(`email`, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'));

-- Teste 1 (FALHA) - e-mail sem arroba.
INSERT INTO `Usuario` (nome, email) VALUES ('Teste Regra 5 - sem arroba', 'usuario-sem-arroba.com');

-- Teste 2 (FALHA) - e-mail sem sufixo de domínio (sem ".algo" após o @).
INSERT INTO `Usuario` (nome, email) VALUES ('Teste Regra 5 - sem tld', 'usuario@dominio');

-- Teste 3 (PASSA) - e-mail em formato válido.
INSERT INTO `Usuario` (nome, email) VALUES ('Teste Regra 5 - valido', 'novo.usuario@baraodemaua.br');
