-- ----------------------------------------------------------------------------
-- QUESTAO 8 - VISAO PARA CONTROLE DE ACESSO
--
-- REQUISITO NAO FUNCIONAL DE SEGURANCA (especificacao):
--   Um auditor externo (ex.: comissao de avaliacao institucional) precisa
--   consultar o resultado dos relatorios de horas dos docentes, mas:
--     (a) so pode ver relatorios JA APROVADOS;
--     (b) nao pode ter acesso a dados pessoais/de login dos docentes;
--     (c) nao pode acessar diretamente nenhuma tabela basica, nem alterar dados.
--
-- SOLUCAO:
--   Visao vw_relatorios_aprovados que combina 5 tabelas (Relatorio, Usuario,
--   Curso, PeriodoLetivo e EventoAuditoria), e um usuario 'auditor_externo'
--   com SELECT somente sobre a visao.
--
-- Decisoes de projeto:
--   * O filtro situacao = 'APROVADO' fica DENTRO da visao: o auditor nao tem
--     como remove-lo, pois nao ve a tabela Relatorio (restricao de linhas);
--   * A lista de colunas e explicita (sem SELECT *);
--   * Nomes de colunas com alias legivel, escondendo ids internos de usuario.
--   * A data de aprovacao vem do evento APROVACAO da trilha de auditoria, e nao
--     de Relatorio.atualizadoEm, que muda a cada UPDATE;
--   * Privilegio concedido: apenas SELECT;
-- ----------------------------------------------------------------------------

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

-- Somente consulta, somente sobre a visao (troque rsha_teste pelo seu banco).
GRANT SELECT ON rsha_teste.vw_relatorios_aprovados TO 'auditor_externo'@'%';

-- Teste 1 (ACEITA) - consulta pela visao: mostra apenas relatorios aprovados,
-- com nome do docente, curso e periodo, sem dados pessoais.
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
