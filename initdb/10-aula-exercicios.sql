DROP DATABASE IF EXISTS aula_exercicios;
CREATE DATABASE aula_exercicios CHARACTER SET utf8mb4;
USE aula_exercicios;

CREATE TABLE professor (
  numero_prof INT PRIMARY KEY,
  profnome    VARCHAR(60) NOT NULL,
  profrua     VARCHAR(60) NOT NULL,
  profcidade  VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE aluno (
  numero_aluno INT PRIMARY KEY,
  alunome      VARCHAR(60) NOT NULL,
  alurua       VARCHAR(60) NOT NULL,
  alucidade    VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE disciplina (
  codigo_disc     INT PRIMARY KEY,
  nome_disciplina VARCHAR(60) NOT NULL,
  nome_curso      VARCHAR(60) NOT NULL,
  qtd_aulas       INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE matricula (
  numero_aluno INT NOT NULL,
  codigo_disc  INT NOT NULL,
  ano          INT NOT NULL,
  PRIMARY KEY (numero_aluno, codigo_disc, ano),
  CONSTRAINT fk_mat_aluno FOREIGN KEY (numero_aluno) REFERENCES aluno(numero_aluno),
  CONSTRAINT fk_mat_disc  FOREIGN KEY (codigo_disc)  REFERENCES disciplina(codigo_disc)
) ENGINE=InnoDB;

CREATE TABLE profdisc (
  codigo_disc INT NOT NULL,
  numero_prof INT NOT NULL,
  ano         INT NOT NULL,
  PRIMARY KEY (codigo_disc, numero_prof, ano),
  CONSTRAINT fk_pd_disc FOREIGN KEY (codigo_disc) REFERENCES disciplina(codigo_disc),
  CONSTRAINT fk_pd_prof FOREIGN KEY (numero_prof) REFERENCES professor(numero_prof)
) ENGINE=InnoDB;

INSERT INTO professor VALUES
  (1,'Carlos Andrade','Rua das Acácias, 100','São Paulo'),
  (2,'Beatriz Lima','Av. Amazonas, 55','Manaus'),
  (3,'Daniel Rocha','Rua XV, 300','Ribeirão Preto'),
  (4,'Elaine Souza','Rua do Porto, 12','Manaus');

INSERT INTO aluno VALUES
  (10,'Michele Silva','Rua A, 1','Manaus'),
  (11,'João Pereira','Rua B, 2','São Paulo'),
  (12,'Ana Castro','Rua C, 3','Manaus'),
  (13,'Bruno Dias','Rua D, 4','Ribeirão Preto'),
  (14,'Michele Silva','Rua E, 5','São Paulo');

INSERT INTO disciplina VALUES
  (984,'Banco de Dados I','Sistemas de Informação',80),
  (985,'Estruturas de Dados','Sistemas de Informação',60),
  (986,'Redes de Computadores','Sistemas de Informação',40),
  (987,'Cálculo I','Engenharia de Produção',90),
  (988,'Compiladores','Ciência da Computação',60);

INSERT INTO profdisc VALUES
  (984,1,YEAR(CURDATE())),
  (985,2,YEAR(CURDATE())),
  (986,3,YEAR(CURDATE())),
  (987,1,YEAR(CURDATE())),
  (988,4,YEAR(CURDATE())),
  (984,2,YEAR(CURDATE())-1);

INSERT INTO matricula VALUES
  (10,984,YEAR(CURDATE())),
  (10,985,YEAR(CURDATE())),
  (11,984,YEAR(CURDATE())),
  (12,986,YEAR(CURDATE())),
  (13,988,YEAR(CURDATE())),
  (14,984,YEAR(CURDATE())),
  (11,987,YEAR(CURDATE())-1);
