-- ----------------------------------------------------------------------------
-- REGRA 1 - Faixa e granularidade das horas de um item de atividade
--
-- Enunciado: um item de atividade deve registrar entre 0,5 e 8 horas, e o
-- valor deve ser multiplo de 0,5 (lancamentos em blocos de meia hora).
--
-- Decisao de projeto: a carga diaria maxima de um docente e 8h, entao um item
-- acima disso indica erro de lancamento (ex.: confundir minutos com horas). O
-- piso de 0,5h evita registros "vazios". O multiplo de meia hora (MOD(horas * 2,
-- 1) = 0) impede valores quebrados como 0,75 e mantem a soma do relatorio em
-- passos de 0,5h.
-- ----------------------------------------------------------------------------
ALTER TABLE ItemAtividade
  ADD CONSTRAINT chk_item_horas_valida
  CHECK (horas >= 0.5 AND horas <= 8 AND MOD(horas * 2, 1) = 0);

-- Teste 1.1 (PASSA) - extremo inferior permitido (0,5h).
INSERT INTO ItemAtividade (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (1, (SELECT COALESCE(MAX(numero), 0) + 1 FROM ItemAtividade i WHERE i.relatorioId = 1), 1, 0.5, 'SEGUNDA', '07h-07h30', 'Teste regra 1 - limite inferior');

-- Teste 1.2 (FALHA) - abaixo do minimo (0,4h).
INSERT INTO ItemAtividade (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (1, (SELECT COALESCE(MAX(numero), 0) + 1 FROM ItemAtividade i WHERE i.relatorioId = 1), 1, 0.4, 'TERCA', '07h-07h24', 'Teste regra 1 - abaixo do minimo');

-- Teste 1.3 (FALHA) - acima do maximo (8,5h, carga de mais de um dia num item so).
INSERT INTO ItemAtividade (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (1, (SELECT COALESCE(MAX(numero), 0) + 1 FROM ItemAtividade i WHERE i.relatorioId = 1), 1, 8.5, 'QUARTA', '07h-15h30', 'Teste regra 1 - acima do maximo');

-- Teste 1.4 (FALHA) - dentro da faixa, mas fora do passo de meia hora (2,75h).
INSERT INTO ItemAtividade (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (1, (SELECT COALESCE(MAX(numero), 0) + 1 FROM ItemAtividade i WHERE i.relatorioId = 1), 1, 2.75, 'SEXTA', '14h-16h45', 'Teste regra 1 - fora do passo de 0,5h');

-- Teste 1.5 (PASSA) - extremo superior permitido (8h).
INSERT INTO ItemAtividade (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (1, (SELECT COALESCE(MAX(numero), 0) + 1 FROM ItemAtividade i WHERE i.relatorioId = 1), 1, 8.0, 'QUINTA', '07h-15h', 'Teste regra 1 - limite superior');

-- Teste 1.6 (FALHA, UPDATE) - alterar um item existente para 9h.
UPDATE ItemAtividade SET horas = 9 WHERE relatorioId = 1 AND numero = 1;


-- ----------------------------------------------------------------------------
-- REGRA 2 - Coerencia de um periodo letivo
--
-- Enunciado: o semestre deve ser 1 ou 2, o ano deve estar entre 2000 e 2100 e
-- o encerramento da submissao deve ser estritamente posterior a abertura.
--
-- Decisao de projeto: usamos ">" (e nao ">=") porque uma janela com abertura e
-- encerramento no mesmo instante nao tem utilidade pratica; isso tambem protege
-- contra inversao acidental das datas. A faixa de ano captura erros de digitacao
-- (202 em vez de 2026) e o semestre so pode ser 1 ou 2.
-- ----------------------------------------------------------------------------
ALTER TABLE PeriodoLetivo
  ADD CONSTRAINT chk_periodo_coerente
  CHECK (semestre IN (1, 2)
         AND ano BETWEEN 2000 AND 2100
         AND encerramentoSubmissao > aberturaSubmissao);

-- Teste 2.1 (FALHA) - abertura e encerramento no mesmo instante.
INSERT INTO PeriodoLetivo (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (2099, 1, '2099-02-01 08:00:00', '2099-02-01 08:00:00');

-- Teste 2.2 (FALHA) - encerramento antes da abertura (datas invertidas).
INSERT INTO PeriodoLetivo (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (2099, 1, '2099-07-10 00:00:00', '2099-02-01 00:00:00');

-- Teste 2.3 (FALHA) - semestre inexistente (3).
INSERT INTO PeriodoLetivo (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (2099, 3, '2099-02-01 00:00:00', '2099-02-10 00:00:00');

-- Teste 2.4 (FALHA) - ano com erro de digitacao (202).
INSERT INTO PeriodoLetivo (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (202, 1, '2026-02-01 00:00:00', '2026-02-10 00:00:00');

-- Teste 2.5 (PASSA) - encerramento um dia apos a abertura.
INSERT INTO PeriodoLetivo (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (2099, 1, '2099-02-01 00:00:00', '2099-02-02 00:00:00');


-- ----------------------------------------------------------------------------
-- REGRA 3 - Carga horaria total do relatorio
--
-- Enunciado: a carga horaria total deve estar entre 0 e 200 horas e um
-- relatorio APROVADO deve ter carga total maior que zero.
--
-- Decisao de projeto: o valor nao deveria nunca ficar negativo, pois e uma soma
-- de horas; o teto de 200h e uma salvaguarda de razoabilidade. A segunda parte e
-- condicional (situacao <> 'APROVADO' OR carga > 0): rascunhos podem ter total
-- zero, mas aprovar um relatorio vazio nao faz sentido.
-- ----------------------------------------------------------------------------
ALTER TABLE Relatorio
  ADD CONSTRAINT chk_relatorio_carga_horaria
  CHECK (cargaHorariaTotal >= 0 AND cargaHorariaTotal <= 200
         AND (situacao <> 'APROVADO' OR cargaHorariaTotal > 0));

-- Teste 3.1 (FALHA) - carga horaria negativa.
UPDATE Relatorio SET cargaHorariaTotal = -5 WHERE id = 1;

-- Teste 3.2 (FALHA) - acima do teto (300h).
UPDATE Relatorio SET cargaHorariaTotal = 300 WHERE id = 1;

-- Teste 3.3 (FALHA) - zerar a carga de um relatorio APROVADO (id 1).
UPDATE Relatorio SET cargaHorariaTotal = 0 WHERE id = 1;

-- Teste 3.4 (PASSA) - carga dentro da faixa plausivel (150h) em relatorio APROVADO.
UPDATE Relatorio SET cargaHorariaTotal = 150 WHERE id = 1;

-- Teste 3.5 (PASSA) - rascunho (id 45) com carga zero: a regra condicional nao o atinge.
UPDATE Relatorio SET cargaHorariaTotal = 0 WHERE id = 45;


-- ----------------------------------------------------------------------------
-- REGRA 4 - Justificativa obrigatoria e substancial em devolucao
--
-- Enunciado: todo evento de auditoria do tipo DEVOLUCAO deve ter justificativa
-- nao nula, com pelo menos 10 caracteres uteis (ignorando espacos nas pontas).
--
-- Decisao de projeto: a devolucao e o unico momento em que o coordenador nega a
-- submissao do docente, entao precisa de motivacao registrada. TRIM() barra a
-- string so de espacos e CHAR_LENGTH >= 10 barra respostas sem sentido ("ok").
-- A regra e condicional (so vale para DEVOLUCAO) para nao obrigar justificativa
-- em CRIACAO, SUBMISSAO e APROVACAO.
-- ----------------------------------------------------------------------------
ALTER TABLE EventoAuditoria
  ADD CONSTRAINT chk_evento_devolucao_justificada
  CHECK (tipo <> 'DEVOLUCAO'
         OR (justificativa IS NOT NULL AND CHAR_LENGTH(TRIM(justificativa)) >= 10));

-- Teste 4.1 (FALHA) - devolucao sem justificativa (NULL).
INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, justificativa)
SELECT 1, 'DEVOLUCAO', MIN(usuarioId), NULL FROM Coordenador;

-- Teste 4.2 (FALHA) - devolucao com justificativa so de espacos.
INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, justificativa)
SELECT 1, 'DEVOLUCAO', MIN(usuarioId), '    ' FROM Coordenador;

-- Teste 4.3 (FALHA) - devolucao com justificativa curta demais ("ok").
INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, justificativa)
SELECT 1, 'DEVOLUCAO', MIN(usuarioId), ' ok ' FROM Coordenador;

-- Teste 4.4 (PASSA) - devolucao com justificativa valida.
INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, justificativa)
SELECT 1, 'DEVOLUCAO', MIN(usuarioId), 'Teste regra 4 - justificativa valida preenchida' FROM Coordenador;

-- Teste 4.5 (PASSA) - aprovacao sem justificativa (mostra que a regra e
-- condicional: so se aplica a DEVOLUCAO, nao aos demais tipos de evento).
INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, justificativa)
SELECT 1, 'APROVACAO', MIN(usuarioId), NULL FROM Coordenador;


-- ----------------------------------------------------------------------------
-- REGRA 5 - Dados de identificacao do usuario
--
-- Enunciado: o e-mail deve seguir "usuario@dominio.tld", escrito apenas em
-- letras minusculas (tld com 2+ letras), e o nome nao pode ser vazio.
--
-- Decisao de projeto: como o login e delegado ao Microsoft Entra ID (sem senha
-- propria), o e-mail amarra o usuario do banco a identidade institucional; um
-- valor mal formatado quebraria essa amarracao. Usamos uma regex simples
-- (REGEXP_LIKE, MySQL 8) em vez da RFC 5322 completa, com o argumento 'c' para
-- aceitar so minusculas, e TRIM(nome) <> '' para barrar nome so de espacos.
-- ----------------------------------------------------------------------------
ALTER TABLE Usuario
  ADD CONSTRAINT chk_usuario_identificacao
  CHECK (REGEXP_LIKE(email, '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$', 'c')
         AND TRIM(nome) <> '');

-- Teste 5.1 (FALHA) - e-mail sem arroba.
INSERT INTO Usuario (nome, email) VALUES ('Teste Regra 5 - sem arroba', 'usuario-sem-arroba.com');

-- Teste 5.2 (FALHA) - e-mail sem sufixo de dominio (sem ".algo" apos o @).
INSERT INTO Usuario (nome, email) VALUES ('Teste Regra 5 - sem tld', 'usuario@dominio');

-- Teste 5.3 (FALHA) - e-mail com letras maiusculas.
INSERT INTO Usuario (nome, email) VALUES ('Teste Regra 5 - maiuscula', 'Novo.Usuario@baraodemaua.br');

-- Teste 5.4 (FALHA) - nome em branco.
INSERT INTO Usuario (nome, email) VALUES ('   ', 'nome.vazio@baraodemaua.br');

-- Teste 5.5 (PASSA) - nome e e-mail validos.
INSERT INTO Usuario (nome, email) VALUES ('Teste Regra 5 - valido', 'novo.usuario@baraodemaua.br');
