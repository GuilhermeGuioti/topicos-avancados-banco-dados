-- ============================================================================
-- QUESTAO 8 - VISAO PARA CONTROLE DE ACESSO
--
-- COMO EXECUTAR (duas conexoes, porque o controle de acesso so e demonstrado
-- quando os testes rodam com o usuario restrito):
--   PARTE A (administrador):   mysql -uroot -p rsha_teste < parte A (ate o GRANT)
--   PARTE B (auditor_externo): mysql -uauditor_externo -pauditor123 --force -t rsha_teste
--                              colando/redirecionando a PARTE B (testes)
--   Rodar a parte B como root NAO demonstra nada: root enxerga tudo.
--   Execucao rapida (a partir deste arquivo):
--     sed -n '1,/^-- -* FIM DA PARTE A/p' questao_8.sql | mysql -uroot -p rsha_teste
--     sed -n '/^-- -* INICIO DA PARTE B/,$p' questao_8.sql | mysql -uauditor_externo -pauditor123 --force -t rsha_teste
--
-- REQUISITO NAO FUNCIONAL DE SEGURANCA (especificacao):
--   Um auditor externo (ex.: comissao de avaliacao institucional) precisa
--   consultar o resultado dos relatorios de horas dos docentes, mas:
--     (a) so pode ver relatorios JA APROVADOS (rascunhos, relatorios em
--         avaliacao e devolvidos sao dados de trabalho, nao resultado);
--     (b) nao pode ter acesso a dados pessoais/de login dos docentes (e-mail,
--         identificador do Entra ID, ids internos);
--     (c) nao pode acessar diretamente nenhuma tabela basica, nem alterar dados.
--
-- SOLUCAO:
--   Visao vw_relatorios_aprovados que combina 5 tabelas basicas (Relatorio,
--   Usuario, Curso, PeriodoLetivo e EventoAuditoria) e um usuario
--   'auditor_externo' com SELECT somente sobre a visao.
--
-- Decisoes de projeto:
--   * Restricao de LINHAS: o filtro situacao = 'APROVADO' fica DENTRO da visao;
--     o auditor nao ve a tabela Relatorio, entao nao tem como remove-lo.
--   * Restricao de COLUNAS: lista explicita (sem SELECT *), com aliases legiveis;
--     ids internos, e-mail e entraOid nao sao expostos. Se a tabela Usuario
--     ganhar novas colunas sensiveis, elas nao vazam pela visao.
--   * A data da aprovacao vem da trilha de auditoria (MAX(ocorridoEm) do evento
--     APROVACAO), e NAO de Relatorio.atualizadoEm: esta coluna muda a cada UPDATE
--     (ON UPDATE CURRENT_TIMESTAMP) e deixaria de representar a aprovacao assim
--     que o relatorio fosse tocado por qualquer outro motivo. Um relatorio pode
--     ter mais de uma aprovacao na trilha, por isso a agregacao em subconsulta.
--   * SQL SECURITY DEFINER (padrao): a visao e executada com os privilegios de
--     quem a criou, o que permite ao auditor le-la sem ter nenhum privilegio
--     sobre as tabelas basicas. (SQL SECURITY INVOKER exigiria SELECT nas tabelas.)
--   * Esta visao, por si so, ACEITARIA UPDATE de colunas que vem de uma unica
--     tabela base (ex.: carga_horaria) para quem tivesse o privilegio. Quem
--     impede a alteracao e o GRANT restrito a SELECT, nao a estrutura da visao
--     (o teste 6 mostra a recusa).
--   * Privilegio concedido: apenas SELECT, apenas sobre a visao. O GRANT usa o
--     banco corrente (USE) em vez de um nome fixo.
-- ============================================================================

-- ------------------------------- PARTE A -------------------------------------
-- (executar como administrador, com o banco do trabalho selecionado)

CREATE OR REPLACE VIEW vw_relatorios_aprovados AS
SELECT r.id                           AS relatorio,
       u.nome                         AS docente,
       c.nome                         AS curso,
       CONCAT(p.ano, '/', p.semestre) AS periodo,
       r.cargaHorariaTotal            AS carga_horaria,
       a.aprovado_em                  AS aprovado_em
  FROM Relatorio r
  INNER JOIN Usuario        u ON u.id = r.docenteId
  INNER JOIN Curso          c ON c.id = r.cursoId
  INNER JOIN PeriodoLetivo  p ON p.id = r.periodoLetivoId
  INNER JOIN (SELECT relatorioId, MAX(ocorridoEm) AS aprovado_em
                FROM EventoAuditoria
               WHERE tipo = 'APROVACAO'
               GROUP BY relatorioId) a ON a.relatorioId = r.id
 WHERE r.situacao = 'APROVADO';

DROP USER IF EXISTS 'auditor_externo'@'%';
CREATE USER 'auditor_externo'@'%' IDENTIFIED BY 'auditor123';

-- Somente consulta, somente sobre a visao (aplica-se ao banco corrente).
GRANT SELECT ON vw_relatorios_aprovados TO 'auditor_externo'@'%';

-- Conferencia (como administrador): o auditor tem USAGE + SELECT na visao, nada mais.
SHOW GRANTS FOR 'auditor_externo'@'%';
-- ------------------------------- FIM DA PARTE A ------------------------------


-- ------------------------------- INICIO DA PARTE B ---------------------------
-- (executar conectado como auditor_externo; use --force para ver todos os erros)

-- Teste 1 (ACEITA) - consulta pela visao: so relatorios aprovados, com nome do
-- docente, curso e periodo, sem dados pessoais nem ids internos.
SELECT * FROM vw_relatorios_aprovados ORDER BY relatorio LIMIT 5;

-- Teste 2 (ACEITA) - agregacao sobre a visao: horas aprovadas por curso.
SELECT curso, COUNT(*) AS relatorios, SUM(carga_horaria) AS horas
  FROM vw_relatorios_aprovados
 GROUP BY curso ORDER BY horas DESC;

-- Teste 3 (RECUSADA, erro 1142) - acesso direto a tabela basica com os
-- relatorios (inclui rascunhos).
SELECT * FROM Relatorio;

-- Teste 4 (RECUSADA, erro 1142) - acesso direto aos dados pessoais.
SELECT nome, email FROM Usuario;

-- Teste 5 (RECUSADA, erro 1054) - coluna que a visao nao expoe (e-mail).
SELECT email FROM vw_relatorios_aprovados;

-- Teste 6 (RECUSADA, erro 1142) - tentativa de alterar dados pela visao: so ha
-- privilegio de SELECT.
UPDATE vw_relatorios_aprovados SET carga_horaria = 200 WHERE relatorio = 1;

-- Teste 7 (RECUSADA, erro 1142) - tentativa de ler a trilha de auditoria
-- diretamente (a visao a usa por dentro, mas o auditor nao pode le-la).
SELECT * FROM EventoAuditoria;
-- ------------------------------- FIM DA PARTE B ------------------------------
