-- ============================================================================
-- QUESTAO 6 - REGRAS DE INTEGRIDADE (CHECK)
--
-- Como executar:  mysql --force -t rsha_teste < questao_6.sql
--   (--force faz o cliente seguir adiante apos os erros ESPERADOS dos testes
--   que "FALHAM"; o comentario de cada teste diz se ele deve PASSAR ou FALHAR).
--
-- Observacoes gerais de projeto:
--   * Todas as regras sao CHECKs sobre colunas que NAO sao chave primaria nem
--     chave estrangeira (o MySQL proibe CHECK em colunas de FK com acoes
--     referenciais ON UPDATE/ON DELETE).
--   * Cada teste roda dentro de START TRANSACTION ... ROLLBACK. Os testes que
--     PASSAM tambem sao desfeitos, entao a base fica identica a antes dos
--     testes (importante: ela segue para o backup final). Um INSERT/UPDATE que
--     viola o CHECK falha atomicamente: nada do comando e gravado.
--   * Os testes escolhem as linhas por consulta (nunca por id fixo), entao
--     funcionam em qualquer carga da base.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- REGRA 1 - Faixa e granularidade das horas de um item de atividade
--
-- Enunciado: um item de atividade deve registrar entre 0,5 e 8 horas, e o
-- valor deve ser multiplo de 0,5 (lancamentos em blocos de meia hora).
--
-- Decisoes de projeto:
--   * A carga diaria maxima de um docente e 8h: acima disso ha erro de
--     lancamento (minutos digitados como horas, varios dias num item so).
--     O piso de 0,5h evita itens "vazios" ou residuais.
--   * O multiplo de meia hora usa MOD(horas * 2, 1) = 0. Multiplicar por 2
--     antes evita comparar um DECIMAL com fracoes (0,5 e exato em DECIMAL, mas
--     o formato "inteiro de blocos" deixa a regra clara). Alem de impedir
--     valores quebrados como 0,75 ou 3,33, isso mantem a soma do relatorio
--     (cargaHorariaTotal) sempre em passos de 0,5h.
--   * As duas condicoes ficam num unico CHECK porque descrevem o mesmo
--     atributo e a mesma intencao: "hora de item valida".
-- ----------------------------------------------------------------------------
ALTER TABLE `ItemAtividade`
  ADD CONSTRAINT `chk_item_horas_valida`
  CHECK (`horas` >= 0.5 AND `horas` <= 8 AND MOD(`horas` * 2, 1) = 0);

-- Teste 1.1 (PASSA) - extremos permitidos: 0,5h e 8h.
START TRANSACTION;
SET @rel := (SELECT MIN(id) FROM `Relatorio`);
SET @num := (SELECT COALESCE(MAX(numero), 0) + 1 FROM `ItemAtividade` WHERE relatorioId = @rel);
INSERT INTO `ItemAtividade` (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (@rel, @num,     (SELECT MIN(id) FROM `TipoAtividade`), 0.5, 'SEGUNDA', '07h-07h30', 'Teste regra 1 - limite inferior'),
       (@rel, @num + 1, (SELECT MIN(id) FROM `TipoAtividade`), 8.0, 'QUINTA',  '07h-15h',    'Teste regra 1 - limite superior');
SELECT numero, horas FROM `ItemAtividade` WHERE relatorioId = @rel AND numero >= @num;
ROLLBACK;

-- Teste 1.2 (FALHA) - abaixo do minimo (0,4h).
START TRANSACTION;
SET @rel := (SELECT MIN(id) FROM `Relatorio`);
SET @num := (SELECT COALESCE(MAX(numero), 0) + 1 FROM `ItemAtividade` WHERE relatorioId = @rel);
INSERT INTO `ItemAtividade` (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (@rel, @num, (SELECT MIN(id) FROM `TipoAtividade`), 0.4, 'TERCA', '07h-07h24', 'Teste regra 1 - abaixo do minimo');
ROLLBACK;

-- Teste 1.3 (FALHA) - acima do maximo (8,5h: carga de mais de um dia num item).
START TRANSACTION;
SET @rel := (SELECT MIN(id) FROM `Relatorio`);
SET @num := (SELECT COALESCE(MAX(numero), 0) + 1 FROM `ItemAtividade` WHERE relatorioId = @rel);
INSERT INTO `ItemAtividade` (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (@rel, @num, (SELECT MIN(id) FROM `TipoAtividade`), 8.5, 'QUARTA', '07h-15h30', 'Teste regra 1 - acima do maximo');
ROLLBACK;

-- Teste 1.4 (FALHA) - dentro da faixa, mas fora do passo de meia hora (2,75h).
START TRANSACTION;
SET @rel := (SELECT MIN(id) FROM `Relatorio`);
SET @num := (SELECT COALESCE(MAX(numero), 0) + 1 FROM `ItemAtividade` WHERE relatorioId = @rel);
INSERT INTO `ItemAtividade` (relatorioId, numero, tipoAtividadeId, horas, diaSemana, horario, descricao)
VALUES (@rel, @num, (SELECT MIN(id) FROM `TipoAtividade`), 2.75, 'SEXTA', '14h-16h45', 'Teste regra 1 - fora do passo de 0,5h');
ROLLBACK;

-- Teste 1.5 (FALHA, UPDATE) - o CHECK tambem vale na alteracao: tentar mudar um
-- item existente para 9h.
START TRANSACTION;
UPDATE `ItemAtividade` SET horas = 9 WHERE relatorioId = (SELECT MIN(id) FROM `Relatorio`) AND numero = 1;
ROLLBACK;


-- ----------------------------------------------------------------------------
-- REGRA 2 - Coerencia de um periodo letivo
--
-- Enunciado: o semestre deve ser 1 ou 2, o ano deve estar entre 2000 e 2100 e
-- o encerramento da submissao deve ser estritamente posterior a abertura.
--
-- Decisoes de projeto:
--   * Usamos ">" (e nao ">=") porque uma janela com abertura e encerramento no
--     mesmo instante nao serve para nada: ninguem conseguiria submeter. A regra
--     tambem barra a inversao acidental das duas datas.
--   * IN (1, 2) em vez de BETWEEN: deixa explicito que so existem dois
--     semestres e que o ano/semestre (UNIQUE) identifica o periodo.
--   * A faixa de ano captura erros de digitacao tipicos (202 em vez de 2026,
--     20266) sem engessar o sistema por muitas decadas.
-- ----------------------------------------------------------------------------
ALTER TABLE `PeriodoLetivo`
  ADD CONSTRAINT `chk_periodo_coerente`
  CHECK (`semestre` IN (1, 2)
         AND `ano` BETWEEN 2000 AND 2100
         AND `encerramentoSubmissao` > `aberturaSubmissao`);

-- Teste 2.1 (FALHA) - abertura e encerramento no mesmo instante.
START TRANSACTION;
INSERT INTO `PeriodoLetivo` (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (2099, 1, '2099-02-01 08:00:00', '2099-02-01 08:00:00');
ROLLBACK;

-- Teste 2.2 (FALHA) - encerramento antes da abertura (datas invertidas).
START TRANSACTION;
INSERT INTO `PeriodoLetivo` (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (2099, 1, '2099-07-10 00:00:00', '2099-02-01 00:00:00');
ROLLBACK;

-- Teste 2.3 (FALHA) - semestre inexistente (3).
START TRANSACTION;
INSERT INTO `PeriodoLetivo` (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (2099, 3, '2099-02-01 00:00:00', '2099-02-10 00:00:00');
ROLLBACK;

-- Teste 2.4 (FALHA) - ano com erro de digitacao (202).
START TRANSACTION;
INSERT INTO `PeriodoLetivo` (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (202, 1, '2026-02-01 00:00:00', '2026-02-10 00:00:00');
ROLLBACK;

-- Teste 2.5 (PASSA) - periodo valido, encerramento um dia apos a abertura.
START TRANSACTION;
INSERT INTO `PeriodoLetivo` (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
VALUES (2099, 1, '2099-02-01 00:00:00', '2099-02-02 00:00:00');
SELECT ano, semestre FROM `PeriodoLetivo` WHERE ano = 2099;
ROLLBACK;


-- ----------------------------------------------------------------------------
-- REGRA 3 - Carga horaria total do relatorio
--
-- Enunciado: a carga horaria total deve estar entre 0 e 200 horas e um
-- relatorio APROVADO deve ter carga total maior que zero.
--
-- Decisoes de projeto:
--   * O total e uma soma de horas de itens, entao nunca deveria ser negativo;
--     o valor negativo so entraria por bug ou UPDATE manual errado. O teto de
--     200h e uma salvaguarda de razoabilidade para um semestre inteiro.
--   * A segunda parte e uma regra CONDICIONAL entre dois atributos
--     (situacao e cargaHorariaTotal), escrita como implicacao logica:
--     "situacao <> 'APROVADO' OR carga > 0". Rascunhos podem ter total zero
--     (acabaram de ser criados), mas aprovar um relatorio vazio nao faz
--     sentido: a aprovacao do coordenador tem de se apoiar em horas declaradas.
-- ----------------------------------------------------------------------------
ALTER TABLE `Relatorio`
  ADD CONSTRAINT `chk_relatorio_carga_horaria`
  CHECK (`cargaHorariaTotal` >= 0 AND `cargaHorariaTotal` <= 200
         AND (`situacao` <> 'APROVADO' OR `cargaHorariaTotal` > 0));

-- Teste 3.1 (FALHA) - carga horaria negativa.
START TRANSACTION;
UPDATE `Relatorio` SET cargaHorariaTotal = -5 WHERE id = (SELECT MIN(id) FROM (SELECT id FROM `Relatorio`) t);
ROLLBACK;

-- Teste 3.2 (FALHA) - acima do teto (300h).
START TRANSACTION;
UPDATE `Relatorio` SET cargaHorariaTotal = 300 WHERE id = (SELECT MIN(id) FROM (SELECT id FROM `Relatorio`) t);
ROLLBACK;

-- Teste 3.3 (FALHA) - zerar a carga de um relatorio APROVADO.
START TRANSACTION;
UPDATE `Relatorio` SET cargaHorariaTotal = 0
 WHERE id = (SELECT MIN(id) FROM (SELECT id FROM `Relatorio` WHERE situacao = 'APROVADO') t);
ROLLBACK;

-- Teste 3.4 (PASSA) - rascunho com carga zero (a regra condicional nao o atinge)
-- e relatorio aprovado com carga dentro da faixa (150h).
START TRANSACTION;
UPDATE `Relatorio` SET cargaHorariaTotal = 0
 WHERE id = (SELECT MIN(id) FROM (SELECT id FROM `Relatorio` WHERE situacao = 'RASCUNHO') t);
UPDATE `Relatorio` SET cargaHorariaTotal = 150
 WHERE id = (SELECT MIN(id) FROM (SELECT id FROM `Relatorio` WHERE situacao = 'APROVADO') t);
ROLLBACK;


-- ----------------------------------------------------------------------------
-- REGRA 4 - Justificativa obrigatoria e substancial em devolucao
--
-- Enunciado: todo evento de auditoria do tipo DEVOLUCAO deve ter justificativa
-- nao nula, com pelo menos 10 caracteres uteis (ignorando espacos nas pontas).
--
-- Decisoes de projeto:
--   * A devolucao e o unico momento em que o coordenador nega a submissao do
--     docente; sem motivacao registrada a trilha de auditoria nao cumpre o
--     papel da antiga assinatura manuscrita (ver contexto do sistema).
--   * TRIM() barra o "furo" de satisfazer um NOT NULL com string de espacos, e
--     CHAR_LENGTH >= 10 barra respostas vazias de sentido ("ok", "x"). O minimo
--     de 10 e menor que a menor justificativa-padrao do sistema (40 caracteres).
--   * A regra e condicional (so vale para DEVOLUCAO) para nao obrigar
--     justificativa em CRIACAO, SUBMISSAO e APROVACAO. Escrita como
--     "tipo <> 'DEVOLUCAO' OR (...)": se o antecedente e falso, vale.
-- ----------------------------------------------------------------------------
ALTER TABLE `EventoAuditoria`
  ADD CONSTRAINT `chk_evento_devolucao_justificada`
  CHECK (`tipo` <> 'DEVOLUCAO'
         OR (`justificativa` IS NOT NULL AND CHAR_LENGTH(TRIM(`justificativa`)) >= 10));

-- Teste 4.1 (FALHA) - devolucao sem justificativa (NULL).
START TRANSACTION;
INSERT INTO `EventoAuditoria` (relatorioId, tipo, usuarioId, justificativa)
VALUES ((SELECT MIN(id) FROM `Relatorio`), 'DEVOLUCAO', (SELECT MIN(usuarioId) FROM `Coordenador`), NULL);
ROLLBACK;

-- Teste 4.2 (FALHA) - justificativa so de espacos.
START TRANSACTION;
INSERT INTO `EventoAuditoria` (relatorioId, tipo, usuarioId, justificativa)
VALUES ((SELECT MIN(id) FROM `Relatorio`), 'DEVOLUCAO', (SELECT MIN(usuarioId) FROM `Coordenador`), '    ');
ROLLBACK;

-- Teste 4.3 (FALHA) - justificativa curta demais ("ok").
START TRANSACTION;
INSERT INTO `EventoAuditoria` (relatorioId, tipo, usuarioId, justificativa)
VALUES ((SELECT MIN(id) FROM `Relatorio`), 'DEVOLUCAO', (SELECT MIN(usuarioId) FROM `Coordenador`), ' ok ');
ROLLBACK;

-- Teste 4.4 (PASSA) - devolucao com justificativa valida e aprovacao sem
-- justificativa (a regra e condicional: so se aplica a DEVOLUCAO).
START TRANSACTION;
INSERT INTO `EventoAuditoria` (relatorioId, tipo, usuarioId, justificativa)
VALUES ((SELECT MIN(id) FROM `Relatorio`), 'DEVOLUCAO', (SELECT MIN(usuarioId) FROM `Coordenador`),
        'Faltou detalhar o horario das atividades.'),
       ((SELECT MIN(id) FROM `Relatorio`), 'APROVACAO', (SELECT MIN(usuarioId) FROM `Coordenador`), NULL);
SELECT tipo, justificativa FROM `EventoAuditoria` ORDER BY id DESC LIMIT 2;
ROLLBACK;


-- ----------------------------------------------------------------------------
-- REGRA 5 - Dados de identificacao do usuario
--
-- Enunciado: o e-mail deve seguir "usuario@dominio.tld", escrito apenas em
-- letras minusculas (tld com 2+ letras), e o nome nao pode ser vazio.
--
-- Decisoes de projeto:
--   * O login e delegado ao Microsoft Entra ID, sem senha propria: o e-mail e o
--     elo entre o usuario do banco e a identidade institucional. Um valor mal
--     formatado quebraria esse elo sem avisar.
--   * Exigir minusculas importa porque a collation padrao (utf8mb4_0900_ai_ci)
--     e insensivel a caixa: sem a regra, "Ana@x.br" e "ana@x.br" seriam o
--     mesmo valor para o UNIQUE mas poderiam coexistir em formatos diferentes
--     no resto do sistema. O 3o argumento 'c' de REGEXP_LIKE forca comparacao
--     sensivel a caixa (sem ele, [a-z] aceitaria maiusculas pela collation).
--   * Regex simples (REGEXP_LIKE, MySQL >= 8.0.4) em vez da RFC 5322 completa,
--     que seria complexa demais para o que a regra precisa garantir.
--   * TRIM(nome) <> '' impede nome so de espacos, que passaria num NOT NULL.
-- ----------------------------------------------------------------------------
ALTER TABLE `Usuario`
  ADD CONSTRAINT `chk_usuario_identificacao`
  CHECK (REGEXP_LIKE(`email`, '^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$', 'c')
         AND TRIM(`nome`) <> '');

-- Teste 5.1 (FALHA) - e-mail sem arroba.
START TRANSACTION;
INSERT INTO `Usuario` (nome, email) VALUES ('Teste Regra 5 - sem arroba', 'usuario-sem-arroba.com');
ROLLBACK;

-- Teste 5.2 (FALHA) - e-mail sem sufixo de dominio.
START TRANSACTION;
INSERT INTO `Usuario` (nome, email) VALUES ('Teste Regra 5 - sem tld', 'usuario@dominio');
ROLLBACK;

-- Teste 5.3 (FALHA) - e-mail com letras maiusculas.
START TRANSACTION;
INSERT INTO `Usuario` (nome, email) VALUES ('Teste Regra 5 - maiuscula', 'Novo.Usuario@baraodemaua.br');
ROLLBACK;

-- Teste 5.4 (FALHA) - nome em branco.
START TRANSACTION;
INSERT INTO `Usuario` (nome, email) VALUES ('   ', 'nome.vazio@baraodemaua.br');
ROLLBACK;

-- Teste 5.5 (PASSA) - nome e e-mail validos.
START TRANSACTION;
INSERT INTO `Usuario` (nome, email) VALUES ('Teste Regra 5 - valido', 'novo.usuario@baraodemaua.br');
SELECT nome, email FROM `Usuario` WHERE email = 'novo.usuario@baraodemaua.br';
ROLLBACK;
