-- ----------------------------------------------------------------------------
-- CONSULTA 1 - Resumo de relatórios por curso e período letivo
--
-- Objetivo: para a Secretaria, mostrar em cada curso/período quantos relatórios
-- foram iniciados, quantos foram aprovados, o total de horas aprovadas e a
-- taxa de aprovação. Só aparecem combinações com pelo menos 2 relatórios.
--
-- Funções de grupo: COUNT, SUM (condicional), AVG + HAVING.
-- ----------------------------------------------------------------------------
SELECT CONCAT(p.ano, '/', p.semestre)                                AS periodo,
       c.nome                                                        AS curso,
       COUNT(*)                                                      AS total_relatorios,
       SUM(r.situacao = 'APROVADO')                                  AS aprovados,
       SUM(r.situacao = 'DEVOLVIDO_PARA_AJUSTE')                     AS devolvidos,
       SUM(CASE WHEN r.situacao = 'APROVADO'
                THEN r.cargaHorariaTotal ELSE 0 END)                 AS horas_aprovadas,
       ROUND(AVG(r.cargaHorariaTotal), 2)                            AS media_horas,
       ROUND(100 * SUM(r.situacao = 'APROVADO') / COUNT(*), 1)       AS pct_aprovacao
FROM Relatorio r
JOIN Curso c          ON c.id = r.cursoId
JOIN PeriodoLetivo p  ON p.id = r.periodoLetivoId
GROUP BY p.id, p.ano, p.semestre, c.id, c.nome
HAVING COUNT(*) >= 2
ORDER BY p.ano DESC, p.semestre DESC, pct_aprovacao DESC, c.nome;


-- ----------------------------------------------------------------------------
-- CONSULTA 2 - Horas aprovadas por tipo de atividade em cada curso
--
-- Objetivo: saber quantas horas cada curso dedicou a orientação de TCC,
-- supervisão de estágio e NBE, considerando só relatórios APROVADOS e tipos
-- com pelo menos 10 horas no curso.
--
-- Funções de grupo: SUM, COUNT, COUNT(DISTINCT), AVG, MAX + HAVING.
-- Junção de 4 tabelas (ItemAtividade, Relatorio, Curso, TipoAtividade).
-- ----------------------------------------------------------------------------
SELECT c.nome                          AS curso,
       ta.descricao                    AS tipo_atividade,
       COUNT(DISTINCT r.docenteId)     AS docentes,
       COUNT(*)                        AS itens,
       SUM(i.horas)                    AS total_horas,
       ROUND(AVG(i.horas), 2)          AS media_horas_por_item,
       MAX(i.horas)                    AS maior_item
FROM ItemAtividade i
JOIN Relatorio r       ON r.id = i.relatorioId
JOIN Curso c           ON c.id = r.cursoId
JOIN TipoAtividade ta  ON ta.id = i.tipoAtividadeId
WHERE r.situacao = 'APROVADO'
GROUP BY c.id, c.nome, ta.id, ta.descricao
HAVING SUM(i.horas) >= 10
ORDER BY c.nome, total_horas DESC;


-- ----------------------------------------------------------------------------
-- CONSULTA 3 - Pendências do período corrente
--
-- Objetivo: listar os docentes vinculados a um curso no período cujo prazo de
-- submissão está aberto hoje e que ainda não entregaram (sem relatório, em
-- RASCUNHO ou DEVOLVIDO_PARA_AJUSTE), com o coordenador do curso e os dias
-- restantes até o encerramento.
--
-- Recursos: junção de 6 tabelas (Usuario entra duas vezes, como docente e
-- como coordenador), LEFT JOIN para incluir quem não tem relatório, COALESCE
-- e aritmética de datas.
-- ----------------------------------------------------------------------------
SELECT d.nome                                          AS docente,
       c.nome                                          AS curso,
       coord.nome                                      AS coordenador,
       COALESCE(r.situacao, 'NAO_INICIADO')            AS situacao,
       TIMESTAMPDIFF(DAY, NOW(), p.encerramentoSubmissao) AS dias_restantes
FROM PeriodoLetivo p
JOIN VinculoDocenteCurso v           ON v.periodoLetivoId = p.id
JOIN Usuario d                       ON d.id = v.docenteId
JOIN Curso c                         ON c.id = v.cursoId
LEFT JOIN Relatorio r                ON r.docenteId = v.docenteId
                                    AND r.cursoId = v.cursoId
                                    AND r.periodoLetivoId = v.periodoLetivoId
LEFT JOIN VinculoCoordenadorCurso vc ON vc.cursoId = c.id
                                    AND vc.periodoLetivoId = p.id
LEFT JOIN Usuario coord              ON coord.id = vc.coordenadorId
WHERE NOW() BETWEEN p.aberturaSubmissao AND p.encerramentoSubmissao
  AND (r.id IS NULL OR r.situacao IN ('RASCUNHO', 'DEVOLVIDO_PARA_AJUSTE'))
ORDER BY c.nome, d.nome;


-- ----------------------------------------------------------------------------
-- CONSULTA 4 - Coordenadores que devolvem mais relatórios que a média
--
-- Objetivo: na trilha de auditoria, achar os coordenadores que emitiram mais
-- devoluções do que a média dos coordenadores, mostrando em quantos relatórios,
-- de quantos cursos e em que intervalo de tempo.
--
-- Funções de grupo: COUNT, COUNT(DISTINCT), MIN, MAX + HAVING com subconsulta
-- (a média é calculada sobre o total de devoluções de cada coordenador).
-- ----------------------------------------------------------------------------
SELECT u.nome                           AS coordenador,
       COUNT(*)                         AS devolucoes,
       COUNT(DISTINCT ea.relatorioId)   AS relatorios_devolvidos,
       COUNT(DISTINCT r.cursoId)        AS cursos,
       MIN(ea.ocorridoEm)               AS primeira_devolucao,
       MAX(ea.ocorridoEm)               AS ultima_devolucao
FROM EventoAuditoria ea
JOIN Usuario u   ON u.id = ea.usuarioId
JOIN Relatorio r ON r.id = ea.relatorioId
WHERE ea.tipo = 'DEVOLUCAO'
GROUP BY u.id, u.nome
HAVING COUNT(*) > (SELECT AVG(qtd)
                   FROM (SELECT COUNT(*) AS qtd
                         FROM EventoAuditoria
                         WHERE tipo = 'DEVOLUCAO'
                         GROUP BY usuarioId) t)
ORDER BY devolucoes DESC, coordenador;
