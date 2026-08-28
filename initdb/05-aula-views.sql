-- ---------------------------------------------------------------------------
-- Esquema condutor da AULA (slides 7 a 30): agencia, conta, emprestimo.
-- É sobre estas tabelas que rodam todas as demonstrações ao vivo.
-- ---------------------------------------------------------------------------
DROP DATABASE IF EXISTS aula_views;
CREATE DATABASE aula_views CHARACTER SET utf8mb4;
USE aula_views;

CREATE TABLE agencia (
  codigo_agencia INT PRIMARY KEY,
  nome_agencia   VARCHAR(40) NOT NULL,
  cidade         VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE conta (
  numero_conta   INT PRIMARY KEY,
  nome_cliente   VARCHAR(60) NOT NULL,
  saldo          DECIMAL(12,2) NOT NULL DEFAULT 0,
  codigo_agencia INT NOT NULL,
  CONSTRAINT fk_conta_ag FOREIGN KEY (codigo_agencia) REFERENCES agencia(codigo_agencia)
) ENGINE=InnoDB;

CREATE TABLE emprestimo (
  numero_emprestimo INT PRIMARY KEY,
  nome_cliente      VARCHAR(60) NOT NULL,
  valor             DECIMAL(12,2) NOT NULL,
  codigo_agencia    INT NOT NULL,
  CONSTRAINT fk_emp_ag FOREIGN KEY (codigo_agencia) REFERENCES agencia(codigo_agencia)
) ENGINE=InnoDB;

INSERT INTO agencia VALUES
  (10,'CENTRO','Ribeirão Preto'),
  (20,'ACAPULCO','Ribeirão Preto'),
  (30,'JARDIM','Franca');

-- Manoel tem conta E empréstimo na CENTRO: é o caso que mostra o efeito do UNION
INSERT INTO conta VALUES
  (101,'Manoel', 15000.00,10),
  (102,'Joana',   2300.00,10),
  (103,'Pedro',  48000.00,20),
  (104,'Ana',      750.00,30);

INSERT INTO emprestimo VALUES
  (901,'Manoel',  5000.00,10),
  (902,'Carla',  12000.00,10),
  (903,'Pedro',   3000.00,20);

CREATE INDEX ix_conta_ag ON conta(codigo_agencia);
CREATE INDEX ix_emp_ag   ON emprestimo(codigo_agencia);
