-- ---------------------------------------------------------------------------
-- Schema do SRHA (rsha) traduzido de PostgreSQL/Prisma para MySQL 8.0 / InnoDB.
-- Estado final das migrations do rsha (perfil SECRETARIA, sem
-- Curso.avaliadorAlternativoId). Nomes de tabelas e colunas idênticos aos do
-- rsha. Roda no banco definido em MYSQL_DATABASE (padrão do entrypoint).
--
-- Traduções: SERIAL -> INT AUTO_INCREMENT; TEXT com índice único -> VARCHAR(255);
-- TIMESTAMP(3) -> DATETIME(3); enums nativos -> ENUM; @updatedAt -> ON UPDATE.
-- ---------------------------------------------------------------------------
SET NAMES utf8mb4;

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

CREATE TABLE `UsuarioPerfil` (
  `id`        INT NOT NULL AUTO_INCREMENT,
  `usuarioId` INT NOT NULL,
  `perfil`    ENUM('DOCENTE','COORDENADOR','SECRETARIA') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UsuarioPerfil_usuarioId_perfil_key` (`usuarioId`,`perfil`),
  CONSTRAINT `UsuarioPerfil_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `Curso` (
  `id`    INT NOT NULL AUTO_INCREMENT,
  `nome`  VARCHAR(255) NOT NULL,
  `ativo` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Curso_nome_key` (`nome`)
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
  UNIQUE KEY `VinculoDocenteCurso_docenteId_cursoId_periodoLetivoId_key` (`docenteId`,`cursoId`,`periodoLetivoId`),
  CONSTRAINT `VinculoDocenteCurso_docenteId_fkey` FOREIGN KEY (`docenteId`) REFERENCES `Usuario`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoDocenteCurso_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoDocenteCurso_periodoLetivoId_fkey` FOREIGN KEY (`periodoLetivoId`) REFERENCES `PeriodoLetivo`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `VinculoCoordenadorCurso` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `coordenadorId` INT NOT NULL,
  `cursoId`       INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `VinculoCoordenadorCurso_coordenadorId_cursoId_key` (`coordenadorId`,`cursoId`),
  CONSTRAINT `VinculoCoordenadorCurso_coordenadorId_fkey` FOREIGN KEY (`coordenadorId`) REFERENCES `Usuario`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoCoordenadorCurso_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso`(`id`)
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
  UNIQUE KEY `Relatorio_docenteId_cursoId_periodoLetivoId_key` (`docenteId`,`cursoId`,`periodoLetivoId`),
  KEY `Relatorio_situacao_cursoId_idx` (`situacao`,`cursoId`),
  CONSTRAINT `Relatorio_docenteId_fkey` FOREIGN KEY (`docenteId`) REFERENCES `Usuario`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Relatorio_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Relatorio_periodoLetivoId_fkey` FOREIGN KEY (`periodoLetivoId`) REFERENCES `PeriodoLetivo`(`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `ItemAtividade` (
  `id`              INT NOT NULL AUTO_INCREMENT,
  `relatorioId`     INT NOT NULL,
  `tipoAtividadeId` INT NOT NULL,
  `horas`           DECIMAL(5,2) NOT NULL,
  `diaSemana`       ENUM('SEGUNDA','TERCA','QUARTA','QUINTA','SEXTA','SABADO') NOT NULL,
  `horario`         VARCHAR(255) NOT NULL,
  `descricao`       TEXT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `ItemAtividade_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ItemAtividade_tipoAtividadeId_fkey` FOREIGN KEY (`tipoAtividadeId`) REFERENCES `TipoAtividade`(`id`)
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
