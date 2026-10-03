-- ---------------------------------------------------------------------------
-- Schema do SRHA em MySQL 8.0 / InnoDB, conforme o modelo relacional do
-- Trabalho I. Roda no banco definido em MYSQL_DATABASE (padrão do entrypoint).
-- ---------------------------------------------------------------------------
SET NAMES utf8mb4;

CREATE TABLE `Campus` (
  `id`     INT NOT NULL AUTO_INCREMENT,
  `nome`   VARCHAR(255) NOT NULL,
  `cidade` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Campus_nome_key` (`nome`)
) ENGINE=InnoDB;

CREATE TABLE `Curso` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nome`     VARCHAR(255) NOT NULL,
  `ativo`    BOOLEAN NOT NULL DEFAULT TRUE,
  `campusId` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Curso_nome_key` (`nome`),
  CONSTRAINT `Curso_campusId_fkey` FOREIGN KEY (`campusId`) REFERENCES `Campus`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Disciplina` (
  `id`      INT NOT NULL AUTO_INCREMENT,
  `nome`    VARCHAR(255) NOT NULL,
  `cursoId` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Disciplina_cursoId_nome_key` (`cursoId`,`nome`),
  CONSTRAINT `Disciplina_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Usuario` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nome`     VARCHAR(255) NOT NULL,
  `email`    VARCHAR(255) NOT NULL,
  `entraOid` VARCHAR(255) NULL,
  `ativo`    BOOLEAN NOT NULL DEFAULT TRUE,
  `criadoEm` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Usuario_email_key` (`email`),
  UNIQUE KEY `Usuario_entraOid_key` (`entraOid`)
) ENGINE=InnoDB;

CREATE TABLE `Docente` (
  `usuarioId` INT NOT NULL,
  PRIMARY KEY (`usuarioId`),
  CONSTRAINT `Docente_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Coordenador` (
  `usuarioId` INT NOT NULL,
  PRIMARY KEY (`usuarioId`),
  CONSTRAINT `Coordenador_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `PeriodoLetivo` (
  `id`                    INT NOT NULL AUTO_INCREMENT,
  `ano`                   INT NOT NULL,
  `semestre`              INT NOT NULL,
  `aberturaSubmissao`     DATETIME(3) NOT NULL,
  `encerramentoSubmissao` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PeriodoLetivo_ano_semestre_key` (`ano`,`semestre`)
) ENGINE=InnoDB;

CREATE TABLE `VinculoDocenteCurso` (
  `id`              INT NOT NULL AUTO_INCREMENT,
  `docenteId`       INT NOT NULL,
  `cursoId`         INT NOT NULL,
  `periodoLetivoId` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `VinculoDocenteCurso_doc_curso_periodo_key` (`docenteId`,`cursoId`,`periodoLetivoId`),
  CONSTRAINT `VinculoDocenteCurso_docenteId_fkey` FOREIGN KEY (`docenteId`) REFERENCES `Docente`(`usuarioId`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoDocenteCurso_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoDocenteCurso_periodoLetivoId_fkey` FOREIGN KEY (`periodoLetivoId`) REFERENCES `PeriodoLetivo`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `VinculoCoordenadorCurso` (
  `id`              INT NOT NULL AUTO_INCREMENT,
  `coordenadorId`   INT NOT NULL,
  `cursoId`         INT NOT NULL,
  `periodoLetivoId` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `VinculoCoordenadorCurso_coord_curso_periodo_key` (`coordenadorId`,`cursoId`,`periodoLetivoId`),
  CONSTRAINT `VinculoCoordenadorCurso_coordenadorId_fkey` FOREIGN KEY (`coordenadorId`) REFERENCES `Coordenador`(`usuarioId`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoCoordenadorCurso_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoCoordenadorCurso_periodoLetivoId_fkey` FOREIGN KEY (`periodoLetivoId`) REFERENCES `PeriodoLetivo`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `TipoAtividade` (
  `id`        INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(255) NOT NULL,
  `ativo`     BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `TipoAtividade_descricao_key` (`descricao`)
) ENGINE=InnoDB;

CREATE TABLE `Relatorio` (
  `id`                INT NOT NULL AUTO_INCREMENT,
  `docenteId`         INT NOT NULL,
  `cursoId`           INT NOT NULL,
  `periodoLetivoId`   INT NOT NULL,
  `situacao`          ENUM('RASCUNHO','AGUARDANDO_AVALIACAO','DEVOLVIDO_PARA_AJUSTE','APROVADO')
                      NOT NULL DEFAULT 'RASCUNHO',
  `cargaHorariaTotal` DECIMAL(6,2) NOT NULL DEFAULT 0,
  `criadoEm`          DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `atualizadoEm`      DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Relatorio_doc_curso_periodo_key` (`docenteId`,`cursoId`,`periodoLetivoId`),
  KEY `Relatorio_situacao_cursoId_idx` (`situacao`,`cursoId`),
  CONSTRAINT `Relatorio_docenteId_fkey` FOREIGN KEY (`docenteId`) REFERENCES `Docente`(`usuarioId`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Relatorio_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Relatorio_periodoLetivoId_fkey` FOREIGN KEY (`periodoLetivoId`) REFERENCES `PeriodoLetivo`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `ItemAtividade` (
  `relatorioId`     INT NOT NULL,
  `numero`          INT NOT NULL,
  `tipoAtividadeId` INT NOT NULL,
  `disciplinaId`    INT NULL,
  `horas`           DECIMAL(5,2) NOT NULL,
  `diaSemana`       ENUM('SEGUNDA','TERCA','QUARTA','QUINTA','SEXTA','SABADO') NOT NULL,
  `horario`         VARCHAR(255) NOT NULL,
  `descricao`       TEXT NOT NULL,
  PRIMARY KEY (`relatorioId`,`numero`),
  CONSTRAINT `ItemAtividade_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ItemAtividade_tipoAtividadeId_fkey` FOREIGN KEY (`tipoAtividadeId`) REFERENCES `TipoAtividade`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ItemAtividade_disciplinaId_fkey` FOREIGN KEY (`disciplinaId`) REFERENCES `Disciplina`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `EventoAuditoria` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `relatorioId`   INT NOT NULL,
  `tipo`          ENUM('CRIACAO','SUBMISSAO','APROVACAO','DEVOLUCAO') NOT NULL,
  `usuarioId`     INT NOT NULL,
  `ocorridoEm`    DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `justificativa` TEXT NULL,
  PRIMARY KEY (`id`),
  KEY `EventoAuditoria_relatorioId_ocorridoEm_idx` (`relatorioId`,`ocorridoEm`),
  CONSTRAINT `EventoAuditoria_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `EventoAuditoria_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Anexo` (
  `id`          INT NOT NULL AUTO_INCREMENT,
  `relatorioId` INT NOT NULL,
  `nomeArquivo` VARCHAR(255) NOT NULL,
  `tamanhoKb`   INT NOT NULL,
  `enviadoEm`   DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  CONSTRAINT `Anexo_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Notificacao` (
  `id`          INT NOT NULL AUTO_INCREMENT,
  `usuarioId`   INT NOT NULL,
  `relatorioId` INT NULL,
  `mensagem`    VARCHAR(255) NOT NULL,
  `lida`        BOOLEAN NOT NULL DEFAULT FALSE,
  `criadaEm`    DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  CONSTRAINT `Notificacao_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Notificacao_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
