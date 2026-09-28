-- ---------------------------------------------------------------------------
-- Carga de teste (reduzida) do SRHA. Mesma ideia da prisma/carga-teste.ts do
-- rsha, em ~1/5 do volume:
--   10 cursos · 4 períodos letivos · 8 coordenadores · 32 docentes
--   ~100 relatórios em todos os estados, com itens e trilha de auditoria.
--
-- Determinística: a "aleatoriedade" vem de CRC32(id), não de RAND(), então
-- recriar o banco gera sempre os mesmos dados. Só as datas do período corrente
-- (e os relatórios dele) andam junto com o dia em que o banco é criado, como no
-- seed do rsha.
--
-- Tabelas auxiliares (_seq, _plano) são apagadas no fim — nada de procedure ou
-- tabela extra fica no banco, para não sujar um futuro mysqldump --routines.
-- ---------------------------------------------------------------------------
SET NAMES utf8mb4;

-- Auxiliar: números 1..100.
CREATE TABLE _seq (n INT PRIMARY KEY) ENGINE=InnoDB;
INSERT INTO _seq (n)
WITH RECURSIVE s(n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM s WHERE n < 100)
SELECT n FROM s;

-- ---------------------------------------------------------------- catálogos --
INSERT INTO TipoAtividade (descricao) VALUES
  ('Orientação de TCC'),
  ('Supervisão de Estágio'),
  ('Participação em NBE');

INSERT INTO Curso (nome) VALUES
  ('Fisioterapia'), ('Nutrição'), ('Educação Física'),
  ('Enfermagem'), ('Psicologia'), ('Direito'), ('Administração'),
  ('Ciência da Computação'), ('Sistemas de Informação'), ('Pedagogia');

-- Período corrente (k=0, janela aberta hoje-30d .. hoje+4d, como no seed do rsha)
-- + 3 semestres anteriores, já encerrados.
SET @idx := YEAR(CURDATE()) * 2 + IF(MONTH(CURDATE()) <= 6, 0, 1);
INSERT INTO PeriodoLetivo (ano, semestre, aberturaSubmissao, encerramentoSubmissao)
SELECT p.ano, p.semestre,
  IF(p.k = 0, NOW(3) - INTERVAL 30 DAY, CONCAT(p.ano, IF(p.semestre = 1, '-02-01', '-08-01'))),
  IF(p.k = 0, NOW(3) + INTERVAL 4 DAY,  CONCAT(p.ano, IF(p.semestre = 1, '-07-10', '-12-10')))
FROM (SELECT n - 1 AS k, (@idx - (n - 1)) DIV 2 AS ano, MOD(@idx - (n - 1), 2) + 1 AS semestre
      FROM _seq WHERE n <= 4) p
ORDER BY p.k;

-- ---------------------------------------------------------------- usuários --
-- Fixos: o cenário do login de desenvolvimento do rsha (seed.ts).
INSERT INTO Usuario (nome, email) VALUES
  ('Secretaria Acadêmica', 'admin@srha.dev'),
  ('Helena Vasconcelos',   'helena@baraodemaua.br'),
  ('Cláudia Ferrari',      'claudia@baraodemaua.br'),
  ('Marcos Rinaldi',       'marcos@baraodemaua.br'),
  ('Paulo Tavares',        'paulo@baraodemaua.br');

-- Coordenadores extras (5) e docentes extras (30) com nomes gerados.
INSERT INTO Usuario (nome, email)
SELECT
  CONCAT(
    ELT(1 + MOD(n * 7, 12), 'Ana','Bruno','Carla','Diego','Elaine','Fábio','Gabriela','Henrique','Isabela','João','Karina','Leonardo'),
    ' ',
    ELT(1 + MOD(n * 5 + n DIV 12, 12), 'Almeida','Barros','Cardoso','Duarte','Esteves','Ferraz','Gouveia','Holanda','Junqueira','Lacerda','Machado','Nogueira')
  ),
  CONCAT('coordenador', LPAD(n, 2, '0'), '@baraodemaua.br')
FROM _seq WHERE n <= 5;

INSERT INTO Usuario (nome, email)
SELECT
  CONCAT(
    ELT(1 + MOD(n * 5, 12), 'Mariana','Nelson','Otávio','Patrícia','Rafael','Sabrina','Tiago','Vanessa','Wagner','Yasmin','Beatriz','Cauê'),
    ' ',
    ELT(1 + MOD(n * 7 + n DIV 12, 12), 'Oliveira','Pimenta','Queiroz','Ramalho','Salgado','Teodoro','Valente','Winter','Xavier','Zanetti','Andrade','Bezerra')
  ),
  CONCAT('docente', LPAD(n, 3, '0'), '@baraodemaua.br')
FROM _seq WHERE n <= 30;

INSERT INTO UsuarioPerfil (usuarioId, perfil)
SELECT id, 'SECRETARIA' FROM Usuario WHERE email = 'admin@srha.dev'
UNION ALL
SELECT id, 'DOCENTE' FROM Usuario
 WHERE email IN ('helena@baraodemaua.br', 'paulo@baraodemaua.br') OR email LIKE 'docente%'
UNION ALL
SELECT id, 'COORDENADOR' FROM Usuario
 WHERE email IN ('claudia@baraodemaua.br', 'marcos@baraodemaua.br', 'paulo@baraodemaua.br')
    OR email LIKE 'coordenador%';

-- ----------------------------------------------------------------- vínculos --
-- Coordenação: Cláudia/Marcos/Paulo nos 3 primeiros cursos (como no rsha);
-- os 7 restantes ciclam entre os 5 coordenadores extras.
INSERT INTO VinculoCoordenadorCurso (coordenadorId, cursoId)
SELECT u.id, c.id
FROM Usuario u
JOIN Curso c ON (u.email = 'claudia@baraodemaua.br' AND c.nome = 'Fisioterapia')
             OR (u.email = 'marcos@baraodemaua.br'  AND c.nome = 'Nutrição')
             OR (u.email = 'paulo@baraodemaua.br'   AND c.nome = 'Educação Física');

INSERT INTO VinculoCoordenadorCurso (coordenadorId, cursoId)
SELECT u.id, c.id
FROM Curso c
JOIN Usuario u ON u.email = CONCAT('coordenador', LPAD(MOD(c.id - 4, 5) + 1, 2, '0'), '@baraodemaua.br')
WHERE c.id > 3;

-- Docência, em todos os períodos. Helena em 2 cursos com coordenadores
-- diferentes; Paulo coordena e leciona Educação Física (caso de autoaprovação).
INSERT INTO VinculoDocenteCurso (docenteId, cursoId, periodoLetivoId)
SELECT u.id, c.id, p.id
FROM Usuario u
JOIN Curso c ON (u.email = 'helena@baraodemaua.br' AND c.nome IN ('Fisioterapia', 'Nutrição'))
             OR (u.email = 'paulo@baraodemaua.br'  AND c.nome = 'Educação Física')
CROSS JOIN PeriodoLetivo p;

-- Docentes extras: 1 curso cada; a cada 7º docente leciona um 2º curso.
INSERT INTO VinculoDocenteCurso (docenteId, cursoId, periodoLetivoId)
SELECT u.id, c.id, p.id
FROM _seq d
JOIN Usuario u ON u.email = CONCAT('docente', LPAD(d.n, 3, '0'), '@baraodemaua.br')
JOIN Curso c ON c.id = MOD(d.n, 10) + 1
             OR (MOD(d.n, 7) = 0 AND c.id = MOD(d.n + 3, 10) + 1)
CROSS JOIN PeriodoLetivo p
WHERE d.n <= 30;

-- ---------------------------------------------------------------- relatórios --
-- Plano: quais vínculos têm relatório (o resto é "não iniciado"), em que
-- situação, e a linha do tempo de cada um. Regras (iguais às do rsha):
--   período encerrado: 85% entregam -> 80% APROVADO / 10% DEVOLVIDO / 10% RASCUNHO
--   período corrente:  40% entregam -> 50% AGUARDANDO / 20% APROVADO /
--                                      15% DEVOLVIDO / 15% RASCUNHO
-- Exceção: quando docente = avaliador (Paulo em Educação Física) o relatório
-- fica em RASCUNHO/AGUARDANDO — não há aprovação, pois autoaprovação é proibida.
CREATE TABLE _plano (
  docenteId       INT NOT NULL,
  cursoId         INT NOT NULL,
  periodoLetivoId INT NOT NULL,
  avaliadorId     INT NOT NULL,
  situacao        VARCHAR(30) NOT NULL,
  abertura        DATETIME(3) NOT NULL,
  fim             DATETIME(3) NOT NULL,
  seed            INT NOT NULL,
  retrabalho      BOOLEAN NOT NULL DEFAULT FALSE,
  t0 DATETIME(3) NULL, t1 DATETIME(3) NULL, tdev DATETIME(3) NULL,
  t2 DATETIME(3) NULL, taprov DATETIME(3) NULL,
  PRIMARY KEY (docenteId, cursoId, periodoLetivoId)
) ENGINE=InnoDB;

INSERT INTO _plano (docenteId, cursoId, periodoLetivoId, avaliadorId, situacao, abertura, fim, seed)
SELECT x.docenteId, x.cursoId, x.periodoLetivoId, x.avaliadorId,
  CASE
    WHEN x.docenteId = x.avaliadorId THEN IF(x.roleta < 50, 'RASCUNHO', 'AGUARDANDO_AVALIACAO')
    WHEN x.encerrado THEN
      CASE WHEN x.roleta < 80 THEN 'APROVADO' WHEN x.roleta < 90 THEN 'DEVOLVIDO_PARA_AJUSTE' ELSE 'RASCUNHO' END
    ELSE
      CASE WHEN x.roleta < 50 THEN 'AGUARDANDO_AVALIACAO' WHEN x.roleta < 70 THEN 'APROVADO'
           WHEN x.roleta < 85 THEN 'DEVOLVIDO_PARA_AJUSTE' ELSE 'RASCUNHO' END
  END,
  x.abertura, LEAST(x.encerramento, NOW(3)), x.id
FROM (
  SELECT v.id, v.docenteId, v.cursoId, v.periodoLetivoId,
    (SELECT MIN(vc.coordenadorId) FROM VinculoCoordenadorCurso vc WHERE vc.cursoId = v.cursoId) AS avaliadorId,
    p.aberturaSubmissao AS abertura, p.encerramentoSubmissao AS encerramento,
    p.encerramentoSubmissao < NOW(3) AS encerrado,
    MOD(CRC32(CONCAT('entrega', v.id)), 100) AS entrega,
    MOD(CRC32(CONCAT('roleta', v.id)), 100)  AS roleta
  FROM VinculoDocenteCurso v
  JOIN PeriodoLetivo p ON p.id = v.periodoLetivoId
) x
WHERE x.entrega < IF(x.encerrado, 85, 40);

-- Linha do tempo (tudo limitado a NOW(3)): criação, submissão, devolução,
-- resubmissão, aprovação. 25% dos APROVADOS passam por uma devolução antes.
UPDATE _plano SET
  t0 = DATE_ADD(abertura, INTERVAL FLOOR(MOD(CRC32(CONCAT('t0', seed)), 1000) / 1000
                                         * TIMESTAMPDIFF(SECOND, abertura, fim)) SECOND),
  retrabalho = (situacao = 'APROVADO' AND MOD(CRC32(CONCAT('retrab', seed)), 100) < 25);
UPDATE _plano SET
  t1 = LEAST(DATE_ADD(t0, INTERVAL 1 + MOD(CRC32(CONCAT('t1', seed)), 5) DAY), fim);
UPDATE _plano SET
  tdev = LEAST(DATE_ADD(t1, INTERVAL 1 + MOD(CRC32(CONCAT('tdev', seed)), 3) DAY), NOW(3));
UPDATE _plano SET
  t2 = LEAST(DATE_ADD(tdev, INTERVAL 1 + MOD(CRC32(CONCAT('t2', seed)), 3) DAY), NOW(3));
UPDATE _plano SET
  taprov = LEAST(DATE_ADD(IF(retrabalho, t2, t1), INTERVAL 1 + MOD(CRC32(CONCAT('ta', seed)), 4) DAY), NOW(3));

INSERT INTO Relatorio (docenteId, cursoId, periodoLetivoId, situacao, cargaHorariaTotal, criadoEm, atualizadoEm)
SELECT docenteId, cursoId, periodoLetivoId, situacao, 0, t0, t0 FROM _plano;

-- Itens: 1 a 3 por relatório; a descrição acompanha o tipo da atividade.
INSERT INTO ItemAtividade (relatorioId, tipoAtividadeId, horas, diaSemana, horario, descricao)
SELECT i.relatorioId, i.tipo,
  (4 + MOD(CRC32(CONCAT('horas', i.chave)), 13)) / 2,
  ELT(1 + MOD(CRC32(CONCAT('dia', i.chave)), 6), 'SEGUNDA','TERCA','QUARTA','QUINTA','SEXTA','SABADO'),
  ELT(1 + MOD(CRC32(CONCAT('hor', i.chave)), 6), '07h-09h','09h-11h','14h-16h','16h-18h','19h-21h','21h-22h40'),
  ELT(2 * (i.tipo - 1) + 1 + MOD(CRC32(CONCAT('desc', i.chave)), 2),
      'Orientação individual de TCC', 'Encontro de orientação em grupo',
      'Reunião de acompanhamento de estágio', 'Visita técnica de supervisão de estágio',
      'Participação em reunião do NBE', 'Correção e parecer de relatórios do NBE')
FROM (
  SELECT r.id AS relatorioId, CONCAT(r.id, '-', s.n) AS chave,
         1 + MOD(CRC32(CONCAT('tipo', r.id, '-', s.n)), 3) AS tipo
  FROM Relatorio r
  JOIN _seq s ON s.n <= 1 + MOD(CRC32(CONCAT('qtde', r.id)), 3)
) i;

-- Trilha de auditoria.
INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'CRIACAO', p.docenteId, p.t0, NULL
FROM _plano p JOIN Relatorio r USING (docenteId, cursoId, periodoLetivoId);

INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'SUBMISSAO', p.docenteId, p.t1, NULL
FROM _plano p JOIN Relatorio r USING (docenteId, cursoId, periodoLetivoId)
WHERE p.situacao <> 'RASCUNHO';

INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'DEVOLUCAO', p.avaliadorId, p.tdev,
  ELT(1 + MOD(CRC32(CONCAT('just', p.seed)), 4),
      'Faltou detalhar o horário da atividade de orientação.',
      'A carga horária declarada não bate com o número de encontros descritos.',
      'O tipo de atividade está classificado errado — confira e corrija.',
      'Descrição muito genérica: detalhe o que foi feito em cada encontro.')
FROM _plano p JOIN Relatorio r USING (docenteId, cursoId, periodoLetivoId)
WHERE p.situacao = 'DEVOLVIDO_PARA_AJUSTE' OR p.retrabalho;

INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'SUBMISSAO', p.docenteId, p.t2, NULL
FROM _plano p JOIN Relatorio r USING (docenteId, cursoId, periodoLetivoId)
WHERE p.retrabalho;

INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, ocorridoEm, justificativa)
SELECT r.id, 'APROVACAO', p.avaliadorId, p.taprov, NULL
FROM _plano p JOIN Relatorio r USING (docenteId, cursoId, periodoLetivoId)
WHERE p.situacao = 'APROVADO';

-- Fecha o total de horas e o "atualizadoEm" (= último evento) de cada relatório.
UPDATE Relatorio r
JOIN (SELECT relatorioId, SUM(horas) AS horas FROM ItemAtividade GROUP BY relatorioId) i
  ON i.relatorioId = r.id
JOIN (SELECT relatorioId, MAX(ocorridoEm) AS ultimo FROM EventoAuditoria GROUP BY relatorioId) e
  ON e.relatorioId = r.id
SET r.cargaHorariaTotal = i.horas,
    r.atualizadoEm      = e.ultimo;

DROP TABLE _plano;
DROP TABLE _seq;
