-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: rsha_teste
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `rsha_teste`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `rsha_teste` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `rsha_teste`;

--
-- Table structure for table `Anexo`
--

DROP TABLE IF EXISTS `Anexo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Anexo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `relatorioId` int NOT NULL,
  `nomeArquivo` varchar(255) NOT NULL,
  `tamanhoKb` int NOT NULL,
  `enviadoEm` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Anexo_relatorioId_fkey` (`relatorioId`),
  CONSTRAINT `Anexo_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Anexo`
--

LOCK TABLES `Anexo` WRITE;
/*!40000 ALTER TABLE `Anexo` DISABLE KEYS */;
INSERT INTO `Anexo` VALUES (1,1,'comprovante_1.pdf',737,'2026-02-26 23:00:28.000'),(2,2,'comprovante_2.pdf',699,'2025-12-05 14:06:14.000'),(3,3,'comprovante_3.pdf',935,'2025-03-24 17:12:00.000'),(4,8,'comprovante_8.pdf',865,'2025-09-29 06:05:16.000'),(5,10,'comprovante_10.pdf',920,'2026-09-27 06:47:38.331'),(6,11,'comprovante_11.pdf',176,'2025-08-05 15:02:24.000'),(7,12,'comprovante_12.pdf',666,'2025-07-04 11:26:24.000'),(8,13,'comprovante_13.pdf',358,'2026-09-18 08:14:02.331'),(9,18,'comprovante_18.pdf',928,'2025-06-12 05:12:00.000'),(10,19,'comprovante_19.pdf',868,'2026-03-12 03:44:09.000'),(11,24,'comprovante_24.pdf',972,'2026-06-19 16:33:07.000'),(12,25,'comprovante_25.pdf',782,'2025-08-17 22:34:33.000'),(13,26,'comprovante_26.pdf',206,'2025-04-15 15:48:28.000'),(14,30,'comprovante_30.pdf',734,'2026-09-14 12:04:26.331'),(15,31,'comprovante_31.pdf',510,'2026-03-09 14:40:48.000'),(16,32,'comprovante_32.pdf',530,'2025-10-11 16:46:04.000'),(17,33,'comprovante_33.pdf',656,'2025-02-08 12:21:07.000'),(18,38,'comprovante_38.pdf',206,'2026-05-31 07:00:00.000'),(19,39,'comprovante_39.pdf',734,'2025-10-09 01:53:16.000'),(20,46,'comprovante_46.pdf',750,'2025-05-19 16:25:55.000'),(21,50,'comprovante_50.pdf',670,'2026-05-24 22:21:36.000'),(22,51,'comprovante_51.pdf',158,'2025-10-13 15:55:40.000'),(23,52,'comprovante_52.pdf',916,'2025-05-10 18:44:09.000'),(24,53,'comprovante_53.pdf',376,'2025-11-12 06:28:19.000'),(25,58,'comprovante_58.pdf',636,'2025-08-26 20:22:04.000'),(26,59,'comprovante_59.pdf',202,'2025-02-05 08:01:55.000'),(27,64,'comprovante_64.pdf',592,'2025-05-03 07:23:02.000'),(28,65,'comprovante_65.pdf',126,'2025-04-30 14:30:43.000'),(29,66,'comprovante_66.pdf',694,'2026-09-13 13:45:14.331'),(30,67,'comprovante_67.pdf',708,'2026-06-07 18:21:07.000'),(31,70,'comprovante_70.pdf',276,'2026-05-27 11:24:57.000'),(32,71,'comprovante_71.pdf',606,'2025-08-29 11:14:52.000'),(33,72,'comprovante_72.pdf',880,'2026-05-29 01:34:33.000'),(34,73,'comprovante_73.pdf',452,'2025-08-23 23:12:00.000'),(35,78,'comprovante_78.pdf',656,'2026-03-31 17:06:14.000'),(36,79,'comprovante_79.pdf',182,'2025-11-15 22:30:14.000'),(37,84,'comprovante_84.pdf',168,'2025-06-25 06:06:43.000'),(38,85,'comprovante_85.pdf',236,'2026-06-04 02:35:02.000'),(39,86,'comprovante_86.pdf',396,'2025-08-31 22:59:02.000'),(40,87,'comprovante_87.pdf',864,'2025-06-30 04:24:28.000'),(41,90,'comprovante_90.pdf',184,'2025-07-08 10:50:24.000'),(42,91,'comprovante_91.pdf',460,'2025-08-23 04:20:09.000'),(43,92,'comprovante_92.pdf',120,'2025-05-25 02:10:33.000'),(44,93,'comprovante_93.pdf',636,'2026-03-20 10:10:04.000'),(45,98,'comprovante_98.pdf',478,'2025-11-29 16:37:26.000'),(46,99,'comprovante_99.pdf',544,'2025-06-19 05:06:14.000');
/*!40000 ALTER TABLE `Anexo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Campus`
--

DROP TABLE IF EXISTS `Campus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Campus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `cidade` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Campus_nome_key` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Campus`
--

LOCK TABLES `Campus` WRITE;
/*!40000 ALTER TABLE `Campus` DISABLE KEYS */;
INSERT INTO `Campus` VALUES (1,'Campus Centro','Ribeirão Preto'),(2,'Campus Jardim Sumaré','Ribeirão Preto');
/*!40000 ALTER TABLE `Campus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Coordenador`
--

DROP TABLE IF EXISTS `Coordenador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Coordenador` (
  `usuarioId` int NOT NULL,
  PRIMARY KEY (`usuarioId`),
  CONSTRAINT `Coordenador_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Coordenador`
--

LOCK TABLES `Coordenador` WRITE;
/*!40000 ALTER TABLE `Coordenador` DISABLE KEYS */;
INSERT INTO `Coordenador` VALUES (2),(3),(4),(5),(6),(7),(8),(9);
/*!40000 ALTER TABLE `Coordenador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Curso`
--

DROP TABLE IF EXISTS `Curso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Curso` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `campusId` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Curso_nome_key` (`nome`),
  KEY `Curso_campusId_fkey` (`campusId`),
  CONSTRAINT `Curso_campusId_fkey` FOREIGN KEY (`campusId`) REFERENCES `Campus` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Curso`
--

LOCK TABLES `Curso` WRITE;
/*!40000 ALTER TABLE `Curso` DISABLE KEYS */;
INSERT INTO `Curso` VALUES (1,'Fisioterapia',1,1),(2,'Nutrição',1,2),(3,'Educação Física',1,1),(4,'Enfermagem',1,2),(5,'Psicologia',1,1),(6,'Direito',1,2),(7,'Administração',1,1),(8,'Ciência da Computação',1,2),(9,'Sistemas de Informação',1,1),(10,'Pedagogia',1,2);
/*!40000 ALTER TABLE `Curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Disciplina`
--

DROP TABLE IF EXISTS `Disciplina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Disciplina` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `cursoId` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Disciplina_cursoId_nome_key` (`cursoId`,`nome`),
  CONSTRAINT `Disciplina_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Disciplina`
--

LOCK TABLES `Disciplina` WRITE;
/*!40000 ALTER TABLE `Disciplina` DISABLE KEYS */;
INSERT INTO `Disciplina` VALUES (1,'Estágio Supervisionado',1),(3,'Prática Profissional',1),(2,'Trabalho de Conclusão de Curso',1),(4,'Estágio Supervisionado',2),(6,'Prática Profissional',2),(5,'Trabalho de Conclusão de Curso',2),(7,'Estágio Supervisionado',3),(9,'Prática Profissional',3),(8,'Trabalho de Conclusão de Curso',3),(10,'Estágio Supervisionado',4),(12,'Prática Profissional',4),(11,'Trabalho de Conclusão de Curso',4),(13,'Estágio Supervisionado',5),(15,'Prática Profissional',5),(14,'Trabalho de Conclusão de Curso',5),(16,'Estágio Supervisionado',6),(18,'Prática Profissional',6),(17,'Trabalho de Conclusão de Curso',6),(19,'Estágio Supervisionado',7),(21,'Prática Profissional',7),(20,'Trabalho de Conclusão de Curso',7),(22,'Estágio Supervisionado',8),(24,'Prática Profissional',8),(23,'Trabalho de Conclusão de Curso',8),(25,'Estágio Supervisionado',9),(27,'Prática Profissional',9),(26,'Trabalho de Conclusão de Curso',9),(28,'Estágio Supervisionado',10),(30,'Prática Profissional',10),(29,'Trabalho de Conclusão de Curso',10);
/*!40000 ALTER TABLE `Disciplina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Docente`
--

DROP TABLE IF EXISTS `Docente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Docente` (
  `usuarioId` int NOT NULL,
  PRIMARY KEY (`usuarioId`),
  CONSTRAINT `Docente_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Docente`
--

LOCK TABLES `Docente` WRITE;
/*!40000 ALTER TABLE `Docente` DISABLE KEYS */;
INSERT INTO `Docente` VALUES (1),(4),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),(41);
/*!40000 ALTER TABLE `Docente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EventoAuditoria`
--

DROP TABLE IF EXISTS `EventoAuditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EventoAuditoria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `relatorioId` int NOT NULL,
  `tipo` enum('CRIACAO','SUBMISSAO','APROVACAO','DEVOLUCAO') NOT NULL,
  `usuarioId` int NOT NULL,
  `ocorridoEm` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `justificativa` text,
  PRIMARY KEY (`id`),
  KEY `EventoAuditoria_relatorioId_ocorridoEm_idx` (`relatorioId`,`ocorridoEm`),
  KEY `EventoAuditoria_usuarioId_fkey` (`usuarioId`),
  CONSTRAINT `EventoAuditoria_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `EventoAuditoria_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_evento_devolucao_justificada` CHECK (((`tipo` <> _utf8mb4'DEVOLUCAO') or ((`justificativa` is not null) and (char_length(trim(`justificativa`)) >= 10))))
) ENGINE=InnoDB AUTO_INCREMENT=381 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EventoAuditoria`
--

LOCK TABLES `EventoAuditoria` WRITE;
/*!40000 ALTER TABLE `EventoAuditoria` DISABLE KEYS */;
INSERT INTO `EventoAuditoria` VALUES (1,1,'CRIACAO',1,'2026-02-26 22:00:28.000',NULL),(2,2,'CRIACAO',1,'2025-12-05 13:06:14.000',NULL),(3,3,'CRIACAO',1,'2025-03-24 16:12:00.000',NULL),(4,4,'CRIACAO',1,'2026-05-15 08:24:00.000',NULL),(5,5,'CRIACAO',1,'2025-08-26 03:38:52.000',NULL),(6,6,'CRIACAO',1,'2025-02-25 00:12:57.000',NULL),(7,7,'CRIACAO',4,'2026-03-29 18:18:43.000',NULL),(8,8,'CRIACAO',4,'2025-09-29 05:05:16.000',NULL),(9,9,'CRIACAO',4,'2025-03-28 04:09:07.000',NULL),(10,10,'CRIACAO',12,'2026-09-27 05:47:38.331',NULL),(11,11,'CRIACAO',12,'2025-08-05 14:02:24.000',NULL),(12,12,'CRIACAO',12,'2025-07-04 10:26:24.000',NULL),(13,13,'CRIACAO',13,'2026-09-18 07:14:02.331',NULL),(14,14,'CRIACAO',13,'2026-06-08 20:03:50.000',NULL),(15,15,'CRIACAO',13,'2025-11-05 03:41:45.000',NULL),(16,16,'CRIACAO',14,'2026-04-25 11:24:00.000',NULL),(17,17,'CRIACAO',14,'2025-08-19 17:35:31.000',NULL),(18,18,'CRIACAO',14,'2025-06-12 04:12:00.000',NULL),(19,19,'CRIACAO',15,'2026-03-12 02:44:09.000',NULL),(20,20,'CRIACAO',15,'2025-10-28 10:12:00.000',NULL),(21,21,'CRIACAO',15,'2025-02-09 10:14:52.000',NULL),(22,22,'CRIACAO',16,'2025-08-12 18:57:36.000',NULL),(23,23,'CRIACAO',17,'2026-09-17 11:04:26.331',NULL),(24,24,'CRIACAO',17,'2026-06-19 15:33:07.000',NULL),(25,25,'CRIACAO',17,'2025-08-17 21:34:33.000',NULL),(26,26,'CRIACAO',17,'2025-04-15 14:48:28.000',NULL),(27,27,'CRIACAO',18,'2026-02-06 02:06:43.000',NULL),(28,28,'CRIACAO',18,'2025-10-22 09:34:33.000',NULL),(29,29,'CRIACAO',18,'2025-05-31 17:26:52.000',NULL),(30,30,'CRIACAO',18,'2026-09-14 11:04:26.331',NULL),(31,31,'CRIACAO',18,'2026-03-09 13:40:48.000',NULL),(32,32,'CRIACAO',18,'2025-10-11 15:46:04.000',NULL),(33,33,'CRIACAO',18,'2025-02-08 11:21:07.000',NULL),(34,34,'CRIACAO',20,'2026-07-09 20:11:02.000',NULL),(35,35,'CRIACAO',20,'2025-11-04 21:24:28.000',NULL),(36,36,'CRIACAO',20,'2025-03-05 02:49:55.000',NULL),(37,37,'CRIACAO',21,'2026-09-29 00:59:38.331',NULL),(38,38,'CRIACAO',21,'2026-05-31 06:00:00.000',NULL),(39,39,'CRIACAO',21,'2025-10-09 00:53:16.000',NULL),(40,40,'CRIACAO',21,'2025-07-08 21:17:16.000',NULL),(41,41,'CRIACAO',22,'2026-09-07 09:09:14.331',NULL),(42,42,'CRIACAO',22,'2025-02-14 08:32:38.000',NULL),(43,43,'CRIACAO',23,'2026-09-14 20:26:02.331',NULL),(44,44,'CRIACAO',23,'2026-04-04 11:41:16.000',NULL),(45,45,'CRIACAO',23,'2025-08-24 10:46:33.000',NULL),(46,46,'CRIACAO',23,'2025-05-19 15:25:55.000',NULL),(47,47,'CRIACAO',24,'2026-09-06 14:26:02.331',NULL),(48,48,'CRIACAO',24,'2026-04-07 04:33:36.000',NULL),(49,49,'CRIACAO',24,'2025-09-22 06:27:21.000',NULL),(50,50,'CRIACAO',25,'2026-05-24 21:21:36.000',NULL),(51,51,'CRIACAO',25,'2025-10-13 14:55:40.000',NULL),(52,52,'CRIACAO',25,'2025-05-10 17:44:09.000',NULL),(53,53,'CRIACAO',25,'2025-11-12 05:28:19.000',NULL),(54,54,'CRIACAO',26,'2026-06-16 18:51:50.000',NULL),(55,55,'CRIACAO',26,'2025-11-24 19:17:45.000',NULL),(56,56,'CRIACAO',26,'2025-06-21 05:42:43.000',NULL),(57,57,'CRIACAO',27,'2026-02-09 17:52:48.000',NULL),(58,58,'CRIACAO',27,'2025-08-26 19:22:04.000',NULL),(59,59,'CRIACAO',27,'2025-02-05 07:01:55.000',NULL),(60,60,'CRIACAO',28,'2026-05-11 20:26:52.000',NULL),(61,61,'CRIACAO',28,'2025-11-06 14:16:48.000',NULL),(62,62,'CRIACAO',29,'2026-04-18 19:07:40.000',NULL),(63,63,'CRIACAO',29,'2025-10-23 20:09:36.000',NULL),(64,64,'CRIACAO',29,'2025-05-03 06:23:02.000',NULL),(65,65,'CRIACAO',30,'2025-04-30 13:30:43.000',NULL),(66,66,'CRIACAO',31,'2026-09-13 12:45:14.331',NULL),(67,67,'CRIACAO',31,'2026-06-07 17:21:07.000',NULL),(68,68,'CRIACAO',31,'2025-08-15 12:59:02.000',NULL),(69,69,'CRIACAO',31,'2025-04-04 11:41:16.000',NULL),(70,70,'CRIACAO',32,'2026-05-27 10:24:57.000',NULL),(71,71,'CRIACAO',32,'2025-08-29 10:14:52.000',NULL),(72,72,'CRIACAO',32,'2026-05-29 00:34:33.000',NULL),(73,73,'CRIACAO',32,'2025-08-23 22:12:00.000',NULL),(74,74,'CRIACAO',32,'2025-04-22 18:31:40.000',NULL),(75,75,'CRIACAO',33,'2026-09-30 10:06:50.331',NULL),(76,76,'CRIACAO',33,'2025-10-22 03:17:16.000',NULL),(77,77,'CRIACAO',33,'2025-03-22 03:08:38.000',NULL),(78,78,'CRIACAO',34,'2026-03-31 16:06:14.000',NULL),(79,79,'CRIACAO',34,'2025-11-15 21:30:14.000',NULL),(80,80,'CRIACAO',34,'2025-06-28 05:36:57.000',NULL),(81,81,'CRIACAO',35,'2026-09-10 19:57:14.331',NULL),(82,82,'CRIACAO',35,'2026-07-08 13:39:21.000',NULL),(83,83,'CRIACAO',35,'2025-09-01 01:07:40.000',NULL),(84,84,'CRIACAO',35,'2025-06-25 05:06:43.000',NULL),(85,85,'CRIACAO',36,'2026-06-04 01:35:02.000',NULL),(86,86,'CRIACAO',36,'2025-08-31 21:59:02.000',NULL),(87,87,'CRIACAO',36,'2025-06-30 03:24:28.000',NULL),(88,88,'CRIACAO',37,'2026-04-20 09:17:16.000',NULL),(89,89,'CRIACAO',37,'2025-09-16 02:41:16.000',NULL),(90,90,'CRIACAO',37,'2025-07-08 09:50:24.000',NULL),(91,91,'CRIACAO',38,'2025-08-23 03:20:09.000',NULL),(92,92,'CRIACAO',38,'2025-05-25 01:10:33.000',NULL),(93,93,'CRIACAO',39,'2026-03-20 09:10:04.000',NULL),(94,94,'CRIACAO',39,'2025-12-06 17:24:00.000',NULL),(95,95,'CRIACAO',39,'2025-02-11 15:40:19.000',NULL),(96,96,'CRIACAO',39,'2026-09-27 16:35:38.331',NULL),(97,97,'CRIACAO',39,'2026-04-29 03:10:04.000',NULL),(98,98,'CRIACAO',39,'2025-11-29 15:37:26.000',NULL),(99,99,'CRIACAO',39,'2025-06-19 04:06:14.000',NULL),(100,100,'CRIACAO',40,'2026-04-23 09:47:31.000',NULL),(101,101,'CRIACAO',40,'2025-11-03 13:58:04.000',NULL),(102,102,'CRIACAO',40,'2025-03-18 03:44:38.000',NULL),(103,103,'CRIACAO',41,'2026-03-19 06:27:21.000',NULL),(104,104,'CRIACAO',41,'2025-05-22 15:56:09.000',NULL),(128,1,'SUBMISSAO',1,'2026-02-27 22:00:28.000',NULL),(129,2,'SUBMISSAO',1,'2025-12-06 13:06:14.000',NULL),(130,3,'SUBMISSAO',1,'2025-03-29 16:12:00.000',NULL),(131,4,'SUBMISSAO',1,'2026-05-17 08:24:00.000',NULL),(132,5,'SUBMISSAO',1,'2025-08-29 03:38:52.000',NULL),(133,6,'SUBMISSAO',1,'2025-03-02 00:12:57.000',NULL),(134,7,'SUBMISSAO',4,'2026-04-03 18:18:43.000',NULL),(135,8,'SUBMISSAO',4,'2025-10-04 05:05:16.000',NULL),(136,10,'SUBMISSAO',12,'2026-09-29 05:47:38.331',NULL),(137,11,'SUBMISSAO',12,'2025-08-07 14:02:24.000',NULL),(138,12,'SUBMISSAO',12,'2025-07-07 10:26:24.000',NULL),(139,13,'SUBMISSAO',13,'2026-09-23 07:14:02.331',NULL),(140,14,'SUBMISSAO',13,'2026-06-11 20:03:50.000',NULL),(141,15,'SUBMISSAO',13,'2025-11-08 03:41:45.000',NULL),(142,16,'SUBMISSAO',14,'2026-04-28 11:24:00.000',NULL),(143,17,'SUBMISSAO',14,'2025-08-24 17:35:31.000',NULL),(144,18,'SUBMISSAO',14,'2025-06-13 04:12:00.000',NULL),(145,19,'SUBMISSAO',15,'2026-03-13 02:44:09.000',NULL),(146,21,'SUBMISSAO',15,'2025-02-13 10:14:52.000',NULL),(147,22,'SUBMISSAO',16,'2025-08-13 18:57:36.000',NULL),(148,23,'SUBMISSAO',17,'2026-09-22 11:04:26.331',NULL),(149,24,'SUBMISSAO',17,'2026-06-20 15:33:07.000',NULL),(150,25,'SUBMISSAO',17,'2025-08-18 21:34:33.000',NULL),(151,26,'SUBMISSAO',17,'2025-04-18 14:48:28.000',NULL),(152,28,'SUBMISSAO',18,'2025-10-27 09:34:33.000',NULL),(153,29,'SUBMISSAO',18,'2025-06-02 17:26:52.000',NULL),(154,30,'SUBMISSAO',18,'2026-09-15 11:04:26.331',NULL),(155,31,'SUBMISSAO',18,'2026-03-12 13:40:48.000',NULL),(156,32,'SUBMISSAO',18,'2025-10-15 15:46:04.000',NULL),(157,33,'SUBMISSAO',18,'2025-02-10 11:21:07.000',NULL),(158,34,'SUBMISSAO',20,'2026-07-10 00:00:00.000',NULL),(159,35,'SUBMISSAO',20,'2025-11-08 21:24:28.000',NULL),(160,36,'SUBMISSAO',20,'2025-03-07 02:49:55.000',NULL),(161,37,'SUBMISSAO',21,'2026-10-03 00:59:38.331',NULL),(162,38,'SUBMISSAO',21,'2026-06-02 06:00:00.000',NULL),(163,39,'SUBMISSAO',21,'2025-10-14 00:53:16.000',NULL),(164,40,'SUBMISSAO',21,'2025-07-10 00:00:00.000',NULL),(165,42,'SUBMISSAO',22,'2025-02-18 08:32:38.000',NULL),(166,43,'SUBMISSAO',23,'2026-09-19 20:26:02.331',NULL),(167,46,'SUBMISSAO',23,'2025-05-24 15:25:55.000',NULL),(168,48,'SUBMISSAO',24,'2026-04-10 04:33:36.000',NULL),(169,49,'SUBMISSAO',24,'2025-09-23 06:27:21.000',NULL),(170,50,'SUBMISSAO',25,'2026-05-26 21:21:36.000',NULL),(171,51,'SUBMISSAO',25,'2025-10-16 14:55:40.000',NULL),(172,52,'SUBMISSAO',25,'2025-05-15 17:44:09.000',NULL),(173,53,'SUBMISSAO',25,'2025-11-16 05:28:19.000',NULL),(174,54,'SUBMISSAO',26,'2026-06-20 18:51:50.000',NULL),(175,55,'SUBMISSAO',26,'2025-11-25 19:17:45.000',NULL),(176,56,'SUBMISSAO',26,'2025-06-22 05:42:43.000',NULL),(177,57,'SUBMISSAO',27,'2026-02-11 17:52:48.000',NULL),(178,58,'SUBMISSAO',27,'2025-08-28 19:22:04.000',NULL),(179,59,'SUBMISSAO',27,'2025-02-09 07:01:55.000',NULL),(180,60,'SUBMISSAO',28,'2026-05-16 20:26:52.000',NULL),(181,61,'SUBMISSAO',28,'2025-11-09 14:16:48.000',NULL),(182,62,'SUBMISSAO',29,'2026-04-22 19:07:40.000',NULL),(183,63,'SUBMISSAO',29,'2025-10-26 20:09:36.000',NULL),(184,64,'SUBMISSAO',29,'2025-05-07 06:23:02.000',NULL),(185,65,'SUBMISSAO',30,'2025-05-04 13:30:43.000',NULL),(186,66,'SUBMISSAO',31,'2026-09-15 12:45:14.331',NULL),(187,67,'SUBMISSAO',31,'2026-06-08 17:21:07.000',NULL),(188,68,'SUBMISSAO',31,'2025-08-20 12:59:02.000',NULL),(189,69,'SUBMISSAO',31,'2025-04-09 11:41:16.000',NULL),(190,70,'SUBMISSAO',32,'2026-05-28 10:24:57.000',NULL),(191,71,'SUBMISSAO',32,'2025-08-30 10:14:52.000',NULL),(192,72,'SUBMISSAO',32,'2026-06-03 00:34:33.000',NULL),(193,73,'SUBMISSAO',32,'2025-08-25 22:12:00.000',NULL),(194,74,'SUBMISSAO',32,'2025-04-26 18:31:40.000',NULL),(195,75,'SUBMISSAO',33,'2026-10-03 14:26:02.500',NULL),(196,76,'SUBMISSAO',33,'2025-10-24 03:17:16.000',NULL),(197,78,'SUBMISSAO',34,'2026-04-04 16:06:14.000',NULL),(198,79,'SUBMISSAO',34,'2025-11-19 21:30:14.000',NULL),(199,80,'SUBMISSAO',34,'2025-07-02 05:36:57.000',NULL),(200,81,'SUBMISSAO',35,'2026-09-14 19:57:14.331',NULL),(201,82,'SUBMISSAO',35,'2026-07-10 00:00:00.000',NULL),(202,84,'SUBMISSAO',35,'2025-06-29 05:06:43.000',NULL),(203,85,'SUBMISSAO',36,'2026-06-08 01:35:02.000',NULL),(204,86,'SUBMISSAO',36,'2025-09-05 21:59:02.000',NULL),(205,87,'SUBMISSAO',36,'2025-07-04 03:24:28.000',NULL),(206,88,'SUBMISSAO',37,'2026-04-24 09:17:16.000',NULL),(207,89,'SUBMISSAO',37,'2025-09-17 02:41:16.000',NULL),(208,90,'SUBMISSAO',37,'2025-07-10 00:00:00.000',NULL),(209,91,'SUBMISSAO',38,'2025-08-25 03:20:09.000',NULL),(210,92,'SUBMISSAO',38,'2025-05-29 01:10:33.000',NULL),(211,93,'SUBMISSAO',39,'2026-03-25 09:10:04.000',NULL),(212,94,'SUBMISSAO',39,'2025-12-09 17:24:00.000',NULL),(213,95,'SUBMISSAO',39,'2025-02-12 15:40:19.000',NULL),(214,96,'SUBMISSAO',39,'2026-09-30 16:35:38.331',NULL),(215,97,'SUBMISSAO',39,'2026-05-03 03:10:04.000',NULL),(216,98,'SUBMISSAO',39,'2025-12-03 15:37:26.000',NULL),(217,99,'SUBMISSAO',39,'2025-06-23 04:06:14.000',NULL),(218,100,'SUBMISSAO',40,'2026-04-28 09:47:31.000',NULL),(219,101,'SUBMISSAO',40,'2025-11-07 13:58:04.000',NULL),(220,102,'SUBMISSAO',40,'2025-03-19 03:44:38.000',NULL),(221,103,'SUBMISSAO',41,'2026-03-24 06:27:21.000',NULL),(255,1,'DEVOLUCAO',2,'2026-02-28 22:00:28.000','O tipo de atividade está classificado errado — confira e corrija.'),(256,2,'DEVOLUCAO',2,'2025-12-09 13:06:14.000','Descrição muito genérica: detalhe o que foi feito em cada encontro.'),(257,3,'DEVOLUCAO',2,'2025-03-30 16:12:00.000','Faltou detalhar o horário da atividade de orientação.'),(258,5,'DEVOLUCAO',3,'2025-08-31 03:38:52.000','A carga horária declarada não bate com o número de encontros descritos.'),(259,14,'DEVOLUCAO',4,'2026-06-14 20:03:50.000','A carga horária declarada não bate com o número de encontros descritos.'),(260,17,'DEVOLUCAO',5,'2025-08-27 17:35:31.000','O tipo de atividade está classificado errado — confira e corrija.'),(261,18,'DEVOLUCAO',5,'2025-06-15 04:12:00.000','Faltou detalhar o horário da atividade de orientação.'),(262,29,'DEVOLUCAO',2,'2025-06-05 17:26:52.000','Faltou detalhar o horário da atividade de orientação.'),(263,34,'DEVOLUCAO',6,'2026-07-11 00:00:00.000','O tipo de atividade está classificado errado — confira e corrija.'),(264,46,'DEVOLUCAO',4,'2025-05-25 15:25:55.000','Faltou detalhar o horário da atividade de orientação.'),(265,50,'DEVOLUCAO',6,'2026-05-29 21:21:36.000','Descrição muito genérica: detalhe o que foi feito em cada encontro.'),(266,53,'DEVOLUCAO',9,'2025-11-19 05:28:19.000','A carga horária declarada não bate com o número de encontros descritos.'),(267,57,'DEVOLUCAO',8,'2026-02-12 17:52:48.000','O tipo de atividade está classificado errado — confira e corrija.'),(268,65,'DEVOLUCAO',6,'2025-05-07 13:30:43.000','Faltou detalhar o horário da atividade de orientação.'),(269,75,'DEVOLUCAO',4,'2026-10-03 14:26:02.535','O tipo de atividade está classificado errado — confira e corrija.'),(270,78,'DEVOLUCAO',5,'2026-04-05 16:06:14.000','A carga horária declarada não bate com o número de encontros descritos.'),(271,80,'DEVOLUCAO',5,'2025-07-05 05:36:57.000','O tipo de atividade está classificado errado — confira e corrija.'),(272,88,'DEVOLUCAO',8,'2026-04-26 09:17:16.000','A carga horária declarada não bate com o número de encontros descritos.'),(273,90,'DEVOLUCAO',8,'2025-07-13 00:00:00.000','O tipo de atividade está classificado errado — confira e corrija.'),(274,91,'DEVOLUCAO',9,'2025-08-28 03:20:09.000','A carga horária declarada não bate com o número de encontros descritos.'),(275,93,'DEVOLUCAO',3,'2026-03-28 09:10:04.000','O tipo de atividade está classificado errado — confira e corrija.'),(276,99,'DEVOLUCAO',5,'2025-06-26 04:06:14.000','A carga horária declarada não bate com o número de encontros descritos.'),(277,100,'DEVOLUCAO',6,'2026-05-01 09:47:31.000','Faltou detalhar o horário da atividade de orientação.'),(286,1,'SUBMISSAO',1,'2026-03-01 22:00:28.000',NULL),(287,2,'SUBMISSAO',1,'2025-12-10 13:06:14.000',NULL),(288,14,'SUBMISSAO',13,'2026-06-16 20:03:50.000',NULL),(289,18,'SUBMISSAO',14,'2025-06-16 04:12:00.000',NULL),(290,34,'SUBMISSAO',20,'2026-07-12 00:00:00.000',NULL),(291,50,'SUBMISSAO',25,'2026-06-01 21:21:36.000',NULL),(292,75,'SUBMISSAO',33,'2026-10-03 14:26:02.544',NULL),(293,78,'SUBMISSAO',34,'2026-04-07 16:06:14.000',NULL),(294,88,'SUBMISSAO',37,'2026-04-28 09:17:16.000',NULL),(295,90,'SUBMISSAO',37,'2025-07-16 00:00:00.000',NULL),(296,93,'SUBMISSAO',39,'2026-03-30 09:10:04.000',NULL),(297,99,'SUBMISSAO',39,'2025-06-28 04:06:14.000',NULL),(301,1,'APROVACAO',2,'2026-03-04 22:00:28.000',NULL),(302,2,'APROVACAO',2,'2025-12-14 13:06:14.000',NULL),(303,4,'APROVACAO',3,'2026-05-21 08:24:00.000',NULL),(304,6,'APROVACAO',3,'2025-03-05 00:12:57.000',NULL),(305,11,'APROVACAO',3,'2025-08-08 14:02:24.000',NULL),(306,12,'APROVACAO',3,'2025-07-10 10:26:24.000',NULL),(307,14,'APROVACAO',4,'2026-06-20 20:03:50.000',NULL),(308,15,'APROVACAO',4,'2025-11-10 03:41:45.000',NULL),(309,16,'APROVACAO',5,'2026-05-01 11:24:00.000',NULL),(310,18,'APROVACAO',5,'2025-06-19 04:12:00.000',NULL),(311,19,'APROVACAO',6,'2026-03-15 02:44:09.000',NULL),(312,21,'APROVACAO',6,'2025-02-16 10:14:52.000',NULL),(313,22,'APROVACAO',7,'2025-08-15 18:57:36.000',NULL),(314,24,'APROVACAO',8,'2026-06-24 15:33:07.000',NULL),(315,25,'APROVACAO',8,'2025-08-21 21:34:33.000',NULL),(316,26,'APROVACAO',8,'2025-04-19 14:48:28.000',NULL),(317,28,'APROVACAO',2,'2025-10-30 09:34:33.000',NULL),(318,31,'APROVACAO',9,'2026-03-14 13:40:48.000',NULL),(319,32,'APROVACAO',9,'2025-10-16 15:46:04.000',NULL),(320,33,'APROVACAO',9,'2025-02-11 11:21:07.000',NULL),(321,34,'APROVACAO',6,'2026-07-13 00:00:00.000',NULL),(322,35,'APROVACAO',6,'2025-11-12 21:24:28.000',NULL),(323,36,'APROVACAO',6,'2025-03-09 02:49:55.000',NULL),(324,38,'APROVACAO',2,'2026-06-04 06:00:00.000',NULL),(325,39,'APROVACAO',2,'2025-10-15 00:53:16.000',NULL),(326,40,'APROVACAO',2,'2025-07-13 00:00:00.000',NULL),(327,42,'APROVACAO',3,'2025-02-22 08:32:38.000',NULL),(328,48,'APROVACAO',5,'2026-04-12 04:33:36.000',NULL),(329,49,'APROVACAO',5,'2025-09-24 06:27:21.000',NULL),(330,50,'APROVACAO',6,'2026-06-03 21:21:36.000',NULL),(331,51,'APROVACAO',6,'2025-10-18 14:55:40.000',NULL),(332,52,'APROVACAO',6,'2025-05-18 17:44:09.000',NULL),(333,54,'APROVACAO',7,'2026-06-22 18:51:50.000',NULL),(334,55,'APROVACAO',7,'2025-11-29 19:17:45.000',NULL),(335,56,'APROVACAO',7,'2025-06-24 05:42:43.000',NULL),(336,58,'APROVACAO',8,'2025-08-31 19:22:04.000',NULL),(337,59,'APROVACAO',8,'2025-02-10 07:01:55.000',NULL),(338,60,'APROVACAO',9,'2026-05-20 20:26:52.000',NULL),(339,61,'APROVACAO',9,'2025-11-12 14:16:48.000',NULL),(340,62,'APROVACAO',5,'2026-04-23 19:07:40.000',NULL),(341,63,'APROVACAO',5,'2025-10-30 20:09:36.000',NULL),(342,64,'APROVACAO',5,'2025-05-09 06:23:02.000',NULL),(343,67,'APROVACAO',2,'2026-06-11 17:21:07.000',NULL),(344,68,'APROVACAO',2,'2025-08-21 12:59:02.000',NULL),(345,69,'APROVACAO',2,'2025-04-12 11:41:16.000',NULL),(346,70,'APROVACAO',3,'2026-05-30 10:24:57.000',NULL),(347,71,'APROVACAO',3,'2025-09-02 10:14:52.000',NULL),(348,72,'APROVACAO',6,'2026-06-07 00:34:33.000',NULL),(349,73,'APROVACAO',6,'2025-08-26 22:12:00.000',NULL),(350,74,'APROVACAO',6,'2025-04-30 18:31:40.000',NULL),(351,75,'APROVACAO',4,'2026-10-03 14:26:02.554',NULL),(352,76,'APROVACAO',4,'2025-10-25 03:17:16.000',NULL),(353,78,'APROVACAO',5,'2026-04-10 16:06:14.000',NULL),(354,79,'APROVACAO',5,'2025-11-23 21:30:14.000',NULL),(355,82,'APROVACAO',6,'2026-07-11 00:00:00.000',NULL),(356,84,'APROVACAO',6,'2025-06-30 05:06:43.000',NULL),(357,85,'APROVACAO',7,'2026-06-10 01:35:02.000',NULL),(358,86,'APROVACAO',7,'2025-09-09 21:59:02.000',NULL),(359,87,'APROVACAO',7,'2025-07-06 03:24:28.000',NULL),(360,88,'APROVACAO',8,'2026-05-01 09:17:16.000',NULL),(361,89,'APROVACAO',8,'2025-09-21 02:41:16.000',NULL),(362,90,'APROVACAO',8,'2025-07-18 00:00:00.000',NULL),(363,92,'APROVACAO',9,'2025-05-30 01:10:33.000',NULL),(364,93,'APROVACAO',3,'2026-04-01 09:10:04.000',NULL),(365,94,'APROVACAO',3,'2025-12-10 17:24:00.000',NULL),(366,95,'APROVACAO',3,'2025-02-13 15:40:19.000',NULL),(367,97,'APROVACAO',5,'2026-05-07 03:10:04.000',NULL),(368,98,'APROVACAO',5,'2025-12-06 15:37:26.000',NULL),(369,99,'APROVACAO',5,'2025-07-01 04:06:14.000',NULL),(370,101,'APROVACAO',6,'2025-11-09 13:58:04.000',NULL),(371,102,'APROVACAO',6,'2025-03-23 03:44:38.000',NULL),(372,103,'APROVACAO',2,'2026-03-25 06:27:21.000',NULL),(373,1,'DEVOLUCAO',2,'2026-10-03 14:28:12.458','Teste regra 4 - justificativa valida preenchida'),(374,1,'APROVACAO',2,'2026-10-03 14:28:12.473',NULL),(375,20,'SUBMISSAO',15,'2026-10-03 14:30:50.006',NULL),(376,10,'APROVACAO',3,'2026-10-03 14:30:50.101',NULL),(377,13,'DEVOLUCAO',4,'2026-10-03 14:30:50.213','Devolvido pelo coordenador para ajuste.'),(378,23,'APROVACAO',8,'2026-10-03 14:30:50.289',NULL),(379,66,'APROVACAO',2,'2026-10-03 14:30:50.289',NULL),(380,81,'APROVACAO',6,'2026-10-03 14:30:50.289',NULL);
/*!40000 ALTER TABLE `EventoAuditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ItemAtividade`
--

DROP TABLE IF EXISTS `ItemAtividade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ItemAtividade` (
  `relatorioId` int NOT NULL,
  `numero` int NOT NULL,
  `tipoAtividadeId` int NOT NULL,
  `disciplinaId` int DEFAULT NULL,
  `horas` decimal(5,2) NOT NULL,
  `diaSemana` enum('SEGUNDA','TERCA','QUARTA','QUINTA','SEXTA','SABADO') NOT NULL,
  `horario` varchar(255) NOT NULL,
  `descricao` text NOT NULL,
  PRIMARY KEY (`relatorioId`,`numero`),
  KEY `ItemAtividade_tipoAtividadeId_fkey` (`tipoAtividadeId`),
  KEY `ItemAtividade_disciplinaId_fkey` (`disciplinaId`),
  CONSTRAINT `ItemAtividade_disciplinaId_fkey` FOREIGN KEY (`disciplinaId`) REFERENCES `Disciplina` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ItemAtividade_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ItemAtividade_tipoAtividadeId_fkey` FOREIGN KEY (`tipoAtividadeId`) REFERENCES `TipoAtividade` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_item_horas_valida` CHECK (((`horas` >= 0.5) and (`horas` <= 8) and (((`horas` * 2) % 1) = 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ItemAtividade`
--

LOCK TABLES `ItemAtividade` WRITE;
/*!40000 ALTER TABLE `ItemAtividade` DISABLE KEYS */;
INSERT INTO `ItemAtividade` VALUES (1,1,3,NULL,5.50,'TERCA','16h-18h','Correção e parecer de relatórios do NBE'),(1,2,1,NULL,0.50,'SEGUNDA','07h-07h30','Teste regra 1 - limite inferior'),(1,3,1,NULL,8.00,'QUINTA','07h-15h','Teste regra 1 - limite superior'),(2,1,1,NULL,4.50,'QUARTA','14h-16h','Orientação individual de TCC'),(2,2,1,NULL,6.50,'SEXTA','07h-09h','Orientação individual de TCC'),(3,1,3,NULL,2.50,'SABADO','09h-11h','Correção e parecer de relatórios do NBE'),(4,1,1,NULL,6.50,'QUARTA','14h-16h','Orientação individual de TCC'),(5,1,1,NULL,3.00,'SABADO','09h-11h','Encontro de orientação em grupo'),(5,2,2,5,6.00,'SABADO','16h-18h','Visita técnica de supervisão de estágio'),(5,3,2,6,8.00,'SABADO','16h-18h','Visita técnica de supervisão de estágio'),(6,1,3,NULL,3.50,'SEXTA','19h-21h','Participação em reunião do NBE'),(7,1,3,NULL,6.50,'SABADO','16h-18h','Correção e parecer de relatórios do NBE'),(8,1,2,7,8.00,'QUARTA','14h-16h','Reunião de acompanhamento de estágio'),(9,1,2,7,4.00,'TERCA','16h-18h','Visita técnica de supervisão de estágio'),(9,2,2,7,5.00,'SABADO','09h-11h','Visita técnica de supervisão de estágio'),(9,3,3,NULL,6.00,'QUINTA','16h-18h','Correção e parecer de relatórios do NBE'),(10,1,2,6,2.50,'SEXTA','16h-18h','Visita técnica de supervisão de estágio'),(10,2,1,NULL,7.00,'QUARTA','16h-18h','Encontro de orientação em grupo'),(10,3,2,4,5.00,'SEXTA','09h-11h','Visita técnica de supervisão de estágio'),(11,1,1,NULL,8.00,'TERCA','07h-09h','Orientação individual de TCC'),(11,2,3,NULL,8.00,'TERCA','07h-09h','Participação em reunião do NBE'),(12,1,2,4,2.00,'SEXTA','21h-22h40','Visita técnica de supervisão de estágio'),(12,2,2,6,2.50,'SEXTA','16h-18h','Visita técnica de supervisão de estágio'),(13,1,3,NULL,3.00,'QUINTA','07h-09h','Participação em reunião do NBE'),(13,2,2,7,2.00,'QUINTA','14h-16h','Reunião de acompanhamento de estágio'),(14,1,1,NULL,2.00,'QUARTA','09h-11h','Encontro de orientação em grupo'),(14,2,3,NULL,6.50,'SEGUNDA','09h-11h','Correção e parecer de relatórios do NBE'),(14,3,3,NULL,5.00,'QUARTA','16h-18h','Correção e parecer de relatórios do NBE'),(15,1,1,NULL,4.50,'TERCA','07h-09h','Orientação individual de TCC'),(16,1,2,12,4.50,'SEGUNDA','21h-22h40','Visita técnica de supervisão de estágio'),(16,2,1,NULL,6.00,'SEGUNDA','21h-22h40','Encontro de orientação em grupo'),(17,1,3,NULL,5.50,'TERCA','14h-16h','Participação em reunião do NBE'),(17,2,1,NULL,7.00,'TERCA','19h-21h','Orientação individual de TCC'),(18,1,2,12,3.00,'QUARTA','09h-11h','Visita técnica de supervisão de estágio'),(18,2,1,NULL,5.50,'QUARTA','16h-18h','Encontro de orientação em grupo'),(19,1,2,14,8.00,'TERCA','07h-09h','Reunião de acompanhamento de estágio'),(19,2,1,NULL,8.00,'QUINTA','14h-16h','Orientação individual de TCC'),(19,3,2,13,2.50,'QUINTA','14h-16h','Reunião de acompanhamento de estágio'),(20,1,2,15,8.00,'SEGUNDA','21h-22h40','Visita técnica de supervisão de estágio'),(21,1,1,NULL,5.50,'SABADO','19h-21h','Orientação individual de TCC'),(21,2,3,NULL,2.00,'QUINTA','14h-16h','Participação em reunião do NBE'),(22,1,2,16,6.00,'QUARTA','09h-11h','Visita técnica de supervisão de estágio'),(22,2,3,NULL,6.00,'QUARTA','09h-11h','Correção e parecer de relatórios do NBE'),(23,1,3,NULL,2.00,'QUINTA','14h-16h','Participação em reunião do NBE'),(24,1,1,NULL,3.50,'QUARTA','21h-22h40','Encontro de orientação em grupo'),(25,1,3,NULL,6.50,'QUINTA','14h-16h','Participação em reunião do NBE'),(25,2,1,NULL,5.50,'SABADO','14h-16h','Orientação individual de TCC'),(25,3,2,20,2.00,'QUINTA','19h-21h','Reunião de acompanhamento de estágio'),(26,1,2,21,7.00,'QUARTA','09h-11h','Visita técnica de supervisão de estágio'),(26,2,3,NULL,7.00,'SEGUNDA','16h-18h','Correção e parecer de relatórios do NBE'),(27,1,3,NULL,8.00,'TERCA','14h-16h','Participação em reunião do NBE'),(27,2,3,NULL,4.50,'QUINTA','14h-16h','Participação em reunião do NBE'),(28,1,1,NULL,7.50,'SEXTA','21h-22h40','Encontro de orientação em grupo'),(28,2,2,3,7.50,'QUARTA','09h-11h','Visita técnica de supervisão de estágio'),(29,1,2,1,5.50,'QUINTA','14h-16h','Reunião de acompanhamento de estágio'),(29,2,1,NULL,4.50,'QUINTA','19h-21h','Orientação individual de TCC'),(29,3,2,1,7.50,'TERCA','19h-21h','Reunião de acompanhamento de estágio'),(30,1,2,22,2.50,'QUINTA','19h-21h','Reunião de acompanhamento de estágio'),(31,1,2,22,4.50,'QUARTA','16h-18h','Visita técnica de supervisão de estágio'),(32,1,2,22,5.50,'TERCA','19h-21h','Reunião de acompanhamento de estágio'),(33,1,1,NULL,7.00,'SEXTA','21h-22h40','Encontro de orientação em grupo'),(34,1,3,NULL,4.00,'TERCA','07h-09h','Participação em reunião do NBE'),(34,2,1,NULL,5.00,'TERCA','14h-16h','Orientação individual de TCC'),(34,3,2,30,5.50,'TERCA','19h-21h','Reunião de acompanhamento de estágio'),(35,1,3,NULL,4.00,'SEXTA','16h-18h','Correção e parecer de relatórios do NBE'),(36,1,1,NULL,5.50,'SABADO','14h-16h','Orientação individual de TCC'),(37,1,2,2,8.00,'SEGUNDA','09h-11h','Visita técnica de supervisão de estágio'),(37,2,1,NULL,3.00,'SEGUNDA','09h-11h','Encontro de orientação em grupo'),(38,1,2,2,3.50,'SABADO','07h-09h','Reunião de acompanhamento de estágio'),(38,2,1,NULL,3.00,'SABADO','19h-21h','Orientação individual de TCC'),(38,3,3,NULL,6.50,'SABADO','19h-21h','Participação em reunião do NBE'),(39,1,1,NULL,6.50,'SEXTA','16h-18h','Encontro de orientação em grupo'),(39,2,1,NULL,4.50,'SEGUNDA','09h-11h','Encontro de orientação em grupo'),(39,3,1,NULL,5.00,'SEGUNDA','21h-22h40','Encontro de orientação em grupo'),(40,1,2,3,6.00,'QUARTA','21h-22h40','Visita técnica de supervisão de estágio'),(40,2,2,2,6.00,'QUARTA','16h-18h','Visita técnica de supervisão de estágio'),(40,3,3,NULL,2.00,'QUARTA','21h-22h40','Correção e parecer de relatórios do NBE'),(41,1,2,6,6.00,'SABADO','19h-21h','Reunião de acompanhamento de estágio'),(42,1,2,5,2.00,'SEGUNDA','16h-18h','Visita técnica de supervisão de estágio'),(42,2,3,NULL,3.00,'QUARTA','21h-22h40','Correção e parecer de relatórios do NBE'),(42,3,3,NULL,4.00,'SEXTA','21h-22h40','Correção e parecer de relatórios do NBE'),(43,1,2,9,8.00,'SABADO','14h-16h','Reunião de acompanhamento de estágio'),(43,2,1,NULL,4.00,'TERCA','07h-09h','Orientação individual de TCC'),(44,1,1,NULL,6.50,'QUARTA','21h-22h40','Encontro de orientação em grupo'),(45,1,3,NULL,3.50,'SABADO','19h-21h','Participação em reunião do NBE'),(46,1,2,9,2.50,'QUARTA','21h-22h40','Visita técnica de supervisão de estágio'),(46,2,3,NULL,3.50,'SEGUNDA','21h-22h40','Correção e parecer de relatórios do NBE'),(46,3,3,NULL,8.00,'SEXTA','21h-22h40','Correção e parecer de relatórios do NBE'),(47,1,1,NULL,6.00,'SABADO','14h-16h','Orientação individual de TCC'),(47,2,3,NULL,7.00,'QUINTA','07h-09h','Participação em reunião do NBE'),(48,1,3,NULL,5.50,'SEXTA','09h-11h','Correção e parecer de relatórios do NBE'),(49,1,2,11,6.00,'SABADO','19h-21h','Reunião de acompanhamento de estágio'),(49,2,3,NULL,4.00,'TERCA','07h-09h','Participação em reunião do NBE'),(50,1,2,14,4.50,'SABADO','14h-16h','Reunião de acompanhamento de estágio'),(51,1,1,NULL,2.50,'SEGUNDA','16h-18h','Encontro de orientação em grupo'),(52,1,1,NULL,6.00,'QUINTA','19h-21h','Orientação individual de TCC'),(53,1,3,NULL,5.00,'SEXTA','21h-22h40','Correção e parecer de relatórios do NBE'),(53,2,1,NULL,2.50,'SEGUNDA','16h-18h','Encontro de orientação em grupo'),(53,3,3,NULL,5.00,'QUARTA','09h-11h','Correção e parecer de relatórios do NBE'),(54,1,1,NULL,8.00,'SABADO','19h-21h','Orientação individual de TCC'),(54,2,2,17,7.00,'TERCA','14h-16h','Reunião de acompanhamento de estágio'),(55,1,1,NULL,5.50,'SEGUNDA','16h-18h','Encontro de orientação em grupo'),(56,1,1,NULL,3.50,'QUINTA','07h-09h','Orientação individual de TCC'),(56,2,1,NULL,6.00,'QUINTA','19h-21h','Orientação individual de TCC'),(56,3,3,NULL,5.00,'SABADO','14h-16h','Participação em reunião do NBE'),(57,1,2,20,5.50,'SEXTA','21h-22h40','Visita técnica de supervisão de estágio'),(57,2,2,19,4.00,'SEGUNDA','21h-22h40','Visita técnica de supervisão de estágio'),(58,1,1,NULL,2.00,'TERCA','07h-09h','Orientação individual de TCC'),(59,1,3,NULL,4.50,'SEXTA','09h-11h','Correção e parecer de relatórios do NBE'),(59,2,2,20,5.50,'SEXTA','09h-11h','Visita técnica de supervisão de estágio'),(60,1,1,NULL,3.00,'QUINTA','07h-09h','Orientação individual de TCC'),(60,2,3,NULL,5.00,'SABADO','14h-16h','Participação em reunião do NBE'),(61,1,2,23,3.50,'SEXTA','21h-22h40','Visita técnica de supervisão de estágio'),(61,2,1,NULL,6.00,'QUARTA','16h-18h','Encontro de orientação em grupo'),(61,3,3,NULL,6.50,'QUARTA','16h-18h','Correção e parecer de relatórios do NBE'),(62,1,3,NULL,5.50,'TERCA','14h-16h','Participação em reunião do NBE'),(62,2,1,NULL,7.50,'SABADO','14h-16h','Orientação individual de TCC'),(62,3,2,27,2.50,'TERCA','19h-21h','Reunião de acompanhamento de estágio'),(63,1,1,NULL,8.00,'QUARTA','16h-18h','Encontro de orientação em grupo'),(63,2,3,NULL,2.50,'QUARTA','16h-18h','Correção e parecer de relatórios do NBE'),(64,1,2,25,2.00,'SABADO','19h-21h','Reunião de acompanhamento de estágio'),(64,2,3,NULL,6.50,'SABADO','14h-16h','Participação em reunião do NBE'),(64,3,3,NULL,8.00,'SABADO','19h-21h','Participação em reunião do NBE'),(65,1,1,NULL,7.00,'QUARTA','21h-22h40','Encontro de orientação em grupo'),(65,2,3,NULL,8.00,'QUARTA','21h-22h40','Correção e parecer de relatórios do NBE'),(65,3,2,28,7.00,'SEGUNDA','21h-22h40','Visita técnica de supervisão de estágio'),(66,1,1,NULL,2.00,'TERCA','19h-21h','Orientação individual de TCC'),(67,1,3,NULL,3.00,'QUARTA','21h-22h40','Correção e parecer de relatórios do NBE'),(67,2,2,1,4.00,'SEGUNDA','09h-11h','Visita técnica de supervisão de estágio'),(67,3,3,NULL,8.00,'SEGUNDA','21h-22h40','Correção e parecer de relatórios do NBE'),(68,1,1,NULL,7.00,'QUINTA','07h-09h','Orientação individual de TCC'),(68,2,1,NULL,4.50,'QUINTA','14h-16h','Orientação individual de TCC'),(68,3,1,NULL,8.00,'SABADO','14h-16h','Orientação individual de TCC'),(69,1,3,NULL,6.50,'SEXTA','09h-11h','Correção e parecer de relatórios do NBE'),(69,2,2,3,5.50,'QUARTA','16h-18h','Visita técnica de supervisão de estágio'),(69,3,3,NULL,7.00,'QUARTA','16h-18h','Correção e parecer de relatórios do NBE'),(70,1,2,6,6.50,'SEXTA','09h-11h','Visita técnica de supervisão de estágio'),(71,1,3,NULL,5.50,'QUINTA','14h-16h','Participação em reunião do NBE'),(72,1,2,14,6.50,'SEXTA','21h-22h40','Visita técnica de supervisão de estágio'),(72,2,3,NULL,4.00,'SEGUNDA','16h-18h','Correção e parecer de relatórios do NBE'),(72,3,1,NULL,2.00,'SEGUNDA','09h-11h','Encontro de orientação em grupo'),(73,1,2,15,5.50,'QUINTA','07h-09h','Reunião de acompanhamento de estágio'),(73,2,1,NULL,8.00,'TERCA','19h-21h','Orientação individual de TCC'),(73,3,3,NULL,3.00,'TERCA','07h-09h','Participação em reunião do NBE'),(74,1,2,13,4.50,'SEXTA','16h-18h','Visita técnica de supervisão de estágio'),(74,2,1,NULL,8.00,'SEXTA','16h-18h','Encontro de orientação em grupo'),(75,1,3,NULL,4.00,'SABADO','19h-21h','Participação em reunião do NBE'),(76,1,2,9,2.50,'SEGUNDA','16h-18h','Visita técnica de supervisão de estágio'),(76,2,1,NULL,5.50,'QUARTA','21h-22h40','Encontro de orientação em grupo'),(76,3,1,NULL,6.50,'QUARTA','16h-18h','Encontro de orientação em grupo'),(77,1,3,NULL,5.50,'TERCA','19h-21h','Participação em reunião do NBE'),(77,2,3,NULL,5.50,'SABADO','14h-16h','Participação em reunião do NBE'),(77,3,1,NULL,6.00,'QUINTA','14h-16h','Orientação individual de TCC'),(78,1,3,NULL,3.50,'QUARTA','16h-18h','Correção e parecer de relatórios do NBE'),(79,1,2,11,2.00,'TERCA','07h-09h','Reunião de acompanhamento de estágio'),(79,2,1,NULL,4.50,'QUINTA','07h-09h','Orientação individual de TCC'),(79,3,2,11,2.00,'TERCA','07h-09h','Reunião de acompanhamento de estágio'),(80,1,1,NULL,5.00,'QUARTA','21h-22h40','Encontro de orientação em grupo'),(81,1,2,13,7.50,'SABADO','19h-21h','Reunião de acompanhamento de estágio'),(81,2,1,NULL,6.00,'SABADO','14h-16h','Orientação individual de TCC'),(82,1,2,14,5.00,'SEGUNDA','21h-22h40','Visita técnica de supervisão de estágio'),(82,2,3,NULL,7.00,'QUARTA','21h-22h40','Correção e parecer de relatórios do NBE'),(82,3,1,NULL,3.50,'SEGUNDA','21h-22h40','Encontro de orientação em grupo'),(83,1,3,NULL,5.00,'SABADO','19h-21h','Participação em reunião do NBE'),(83,2,2,14,3.50,'TERCA','07h-09h','Reunião de acompanhamento de estágio'),(83,3,1,NULL,5.00,'TERCA','14h-16h','Orientação individual de TCC'),(84,1,2,15,6.00,'QUARTA','21h-22h40','Visita técnica de supervisão de estágio'),(84,2,1,NULL,8.00,'SEXTA','16h-18h','Encontro de orientação em grupo'),(84,3,1,NULL,3.50,'SEXTA','21h-22h40','Encontro de orientação em grupo'),(85,1,1,NULL,4.50,'TERCA','07h-09h','Orientação individual de TCC'),(85,2,1,NULL,5.50,'SABADO','19h-21h','Orientação individual de TCC'),(86,1,3,NULL,3.50,'SEXTA','16h-18h','Correção e parecer de relatórios do NBE'),(86,2,3,NULL,5.50,'SEXTA','16h-18h','Correção e parecer de relatórios do NBE'),(86,3,3,NULL,2.50,'SEGUNDA','16h-18h','Correção e parecer de relatórios do NBE'),(87,1,2,17,6.50,'QUINTA','14h-16h','Reunião de acompanhamento de estágio'),(87,2,2,16,2.50,'SABADO','19h-21h','Reunião de acompanhamento de estágio'),(88,1,2,20,7.00,'QUARTA','09h-11h','Visita técnica de supervisão de estágio'),(88,2,2,20,8.00,'QUARTA','21h-22h40','Visita técnica de supervisão de estágio'),(89,1,2,21,4.00,'SABADO','19h-21h','Reunião de acompanhamento de estágio'),(89,2,1,NULL,8.00,'SABADO','07h-09h','Orientação individual de TCC'),(89,3,3,NULL,3.50,'SABADO','19h-21h','Participação em reunião do NBE'),(90,1,1,NULL,5.00,'QUINTA','19h-21h','Orientação individual de TCC'),(90,2,2,21,8.00,'TERCA','14h-16h','Reunião de acompanhamento de estágio'),(91,1,1,NULL,4.00,'SEGUNDA','21h-22h40','Encontro de orientação em grupo'),(92,1,1,NULL,7.00,'TERCA','19h-21h','Orientação individual de TCC'),(93,1,1,NULL,2.50,'SEXTA','21h-22h40','Encontro de orientação em grupo'),(93,2,3,NULL,3.00,'SEGUNDA','16h-18h','Correção e parecer de relatórios do NBE'),(93,3,2,6,3.50,'QUARTA','16h-18h','Visita técnica de supervisão de estágio'),(94,1,3,NULL,6.50,'TERCA','14h-16h','Participação em reunião do NBE'),(94,2,1,NULL,6.50,'TERCA','19h-21h','Orientação individual de TCC'),(94,3,3,NULL,4.00,'QUINTA','19h-21h','Participação em reunião do NBE'),(95,1,1,NULL,2.50,'SEXTA','21h-22h40','Encontro de orientação em grupo'),(95,2,3,NULL,7.50,'SEGUNDA','09h-11h','Correção e parecer de relatórios do NBE'),(96,1,3,NULL,6.50,'TERCA','19h-21h','Participação em reunião do NBE'),(96,2,2,27,6.00,'SABADO','14h-16h','Reunião de acompanhamento de estágio'),(97,1,2,26,2.50,'SEXTA','09h-11h','Visita técnica de supervisão de estágio'),(97,2,1,NULL,3.00,'SEXTA','09h-11h','Encontro de orientação em grupo'),(98,1,2,26,4.00,'TERCA','07h-09h','Reunião de acompanhamento de estágio'),(98,2,3,NULL,5.00,'QUINTA','14h-16h','Participação em reunião do NBE'),(98,3,1,NULL,2.50,'SABADO','19h-21h','Orientação individual de TCC'),(99,1,1,NULL,3.50,'SEXTA','21h-22h40','Encontro de orientação em grupo'),(99,2,1,NULL,8.00,'SEGUNDA','21h-22h40','Encontro de orientação em grupo'),(100,1,3,NULL,5.50,'QUINTA','09h-11h','Correção e parecer de relatórios do NBE'),(101,1,3,NULL,2.50,'QUARTA','19h-21h','Participação em reunião do NBE'),(102,1,1,NULL,4.00,'TERCA','09h-11h','Encontro de orientação em grupo'),(102,2,2,30,5.00,'TERCA','09h-11h','Visita técnica de supervisão de estágio'),(102,3,2,28,3.50,'TERCA','16h-18h','Visita técnica de supervisão de estágio'),(103,1,3,NULL,5.00,'QUARTA','19h-21h','Participação em reunião do NBE'),(103,2,3,NULL,3.50,'SEXTA','14h-16h','Participação em reunião do NBE'),(103,3,1,NULL,8.00,'SEXTA','07h-09h','Orientação individual de TCC'),(104,1,1,NULL,7.00,'TERCA','21h-22h40','Encontro de orientação em grupo'),(104,2,2,3,2.00,'SABADO','21h-22h40','Visita técnica de supervisão de estágio'),(104,3,1,NULL,2.00,'SABADO','09h-11h','Encontro de orientação em grupo');
/*!40000 ALTER TABLE `ItemAtividade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notificacao`
--

DROP TABLE IF EXISTS `Notificacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notificacao` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuarioId` int NOT NULL,
  `relatorioId` int DEFAULT NULL,
  `mensagem` varchar(255) NOT NULL,
  `lida` tinyint(1) NOT NULL DEFAULT '0',
  `criadaEm` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Notificacao_usuarioId_fkey` (`usuarioId`),
  KEY `Notificacao_relatorioId_fkey` (`relatorioId`),
  CONSTRAINT `Notificacao_relatorioId_fkey` FOREIGN KEY (`relatorioId`) REFERENCES `Relatorio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Notificacao_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notificacao`
--

LOCK TABLES `Notificacao` WRITE;
/*!40000 ALTER TABLE `Notificacao` DISABLE KEYS */;
INSERT INTO `Notificacao` VALUES (1,4,7,'Relatório aguardando sua avaliação.',1,'2026-04-03 18:18:43.000'),(2,4,8,'Relatório aguardando sua avaliação.',0,'2025-10-04 05:05:16.000'),(3,3,10,'Relatório aguardando sua avaliação.',1,'2026-09-29 05:47:38.331'),(4,4,13,'Relatório aguardando sua avaliação.',1,'2026-09-23 07:14:02.331'),(5,8,23,'Relatório aguardando sua avaliação.',0,'2026-09-22 11:04:26.331'),(6,9,30,'Relatório aguardando sua avaliação.',1,'2026-09-15 11:04:26.331'),(7,2,37,'Relatório aguardando sua avaliação.',0,'2026-10-03 00:59:38.331'),(8,4,43,'Relatório aguardando sua avaliação.',0,'2026-09-19 20:26:02.331'),(9,2,66,'Relatório aguardando sua avaliação.',1,'2026-09-15 12:45:14.331'),(10,6,81,'Relatório aguardando sua avaliação.',0,'2026-09-14 19:57:14.331'),(11,5,96,'Relatório aguardando sua avaliação.',0,'2026-09-30 16:35:38.331'),(16,1,3,'Relatório devolvido para ajuste.',0,'2025-03-30 16:12:00.000'),(17,1,5,'Relatório devolvido para ajuste.',1,'2025-08-31 03:38:52.000'),(18,14,17,'Relatório devolvido para ajuste.',0,'2025-08-27 17:35:31.000'),(19,18,29,'Relatório devolvido para ajuste.',0,'2025-06-05 17:26:52.000'),(20,23,46,'Relatório devolvido para ajuste.',1,'2025-05-25 15:25:55.000'),(21,25,53,'Relatório devolvido para ajuste.',1,'2025-11-19 05:28:19.000'),(22,27,57,'Relatório devolvido para ajuste.',0,'2026-02-12 17:52:48.000'),(23,30,65,'Relatório devolvido para ajuste.',1,'2025-05-07 13:30:43.000'),(24,34,80,'Relatório devolvido para ajuste.',0,'2025-07-05 05:36:57.000'),(25,38,91,'Relatório devolvido para ajuste.',1,'2025-08-28 03:20:09.000'),(26,40,100,'Relatório devolvido para ajuste.',0,'2026-05-01 09:47:31.000');
/*!40000 ALTER TABLE `Notificacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PeriodoLetivo`
--

DROP TABLE IF EXISTS `PeriodoLetivo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PeriodoLetivo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ano` int NOT NULL,
  `semestre` int NOT NULL,
  `aberturaSubmissao` datetime(3) NOT NULL,
  `encerramentoSubmissao` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PeriodoLetivo_ano_semestre_key` (`ano`,`semestre`),
  CONSTRAINT `chk_periodo_coerente` CHECK (((`semestre` in (1,2)) and (`ano` between 2000 and 2100) and (`encerramentoSubmissao` > `aberturaSubmissao`)))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PeriodoLetivo`
--

LOCK TABLES `PeriodoLetivo` WRITE;
/*!40000 ALTER TABLE `PeriodoLetivo` DISABLE KEYS */;
INSERT INTO `PeriodoLetivo` VALUES (1,2026,2,'2026-09-03 14:26:02.331','2026-10-07 14:26:02.331'),(2,2026,1,'2026-02-01 00:00:00.000','2026-07-10 00:00:00.000'),(3,2025,2,'2025-08-01 00:00:00.000','2025-12-10 00:00:00.000'),(4,2025,1,'2025-02-01 00:00:00.000','2025-07-10 00:00:00.000'),(5,2099,1,'2099-02-01 00:00:00.000','2099-02-02 00:00:00.000');
/*!40000 ALTER TABLE `PeriodoLetivo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Relatorio`
--

DROP TABLE IF EXISTS `Relatorio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Relatorio` (
  `id` int NOT NULL AUTO_INCREMENT,
  `docenteId` int NOT NULL,
  `cursoId` int NOT NULL,
  `periodoLetivoId` int NOT NULL,
  `situacao` enum('RASCUNHO','AGUARDANDO_AVALIACAO','DEVOLVIDO_PARA_AJUSTE','APROVADO') NOT NULL DEFAULT 'RASCUNHO',
  `cargaHorariaTotal` decimal(6,2) NOT NULL DEFAULT '0.00',
  `criadoEm` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `atualizadoEm` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Relatorio_doc_curso_periodo_key` (`docenteId`,`cursoId`,`periodoLetivoId`),
  KEY `Relatorio_situacao_cursoId_idx` (`situacao`,`cursoId`),
  KEY `Relatorio_cursoId_fkey` (`cursoId`),
  KEY `Relatorio_periodoLetivoId_fkey` (`periodoLetivoId`),
  CONSTRAINT `Relatorio_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Relatorio_docenteId_fkey` FOREIGN KEY (`docenteId`) REFERENCES `Docente` (`usuarioId`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Relatorio_periodoLetivoId_fkey` FOREIGN KEY (`periodoLetivoId`) REFERENCES `PeriodoLetivo` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_relatorio_carga_horaria` CHECK (((`cargaHorariaTotal` >= 0) and (`cargaHorariaTotal` <= 200) and ((`situacao` <> _utf8mb4'APROVADO') or (`cargaHorariaTotal` > 0))))
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Relatorio`
--

LOCK TABLES `Relatorio` WRITE;
/*!40000 ALTER TABLE `Relatorio` DISABLE KEYS */;
INSERT INTO `Relatorio` VALUES (1,1,1,2,'APROVADO',200.00,'2026-02-26 22:00:28.000','2026-10-03 14:31:26.213'),(2,1,1,3,'APROVADO',11.00,'2025-12-05 13:06:14.000','2025-12-14 13:06:14.000'),(3,1,1,4,'DEVOLVIDO_PARA_AJUSTE',2.50,'2025-03-24 16:12:00.000','2025-03-30 16:12:00.000'),(4,1,2,2,'APROVADO',6.50,'2026-05-15 08:24:00.000','2026-05-21 08:24:00.000'),(5,1,2,3,'DEVOLVIDO_PARA_AJUSTE',17.00,'2025-08-26 03:38:52.000','2025-08-31 03:38:52.000'),(6,1,2,4,'APROVADO',3.50,'2025-02-25 00:12:57.000','2025-03-05 00:12:57.000'),(7,4,3,2,'AGUARDANDO_AVALIACAO',6.50,'2026-03-29 18:18:43.000','2026-04-03 18:18:43.000'),(8,4,3,3,'AGUARDANDO_AVALIACAO',8.00,'2025-09-29 05:05:16.000','2025-10-04 05:05:16.000'),(9,4,3,4,'RASCUNHO',15.00,'2025-03-28 04:09:07.000','2025-03-28 04:09:07.000'),(10,12,2,1,'APROVADO',14.50,'2026-09-27 05:47:38.331','2026-10-03 14:30:50.101'),(11,12,2,3,'APROVADO',16.00,'2025-08-05 14:02:24.000','2025-08-08 14:02:24.000'),(12,12,2,4,'APROVADO',4.50,'2025-07-04 10:26:24.000','2025-07-10 10:26:24.000'),(13,13,3,1,'DEVOLVIDO_PARA_AJUSTE',5.00,'2026-09-18 07:14:02.331','2026-10-03 14:30:50.213'),(14,13,3,2,'APROVADO',13.50,'2026-06-08 20:03:50.000','2026-06-20 20:03:50.000'),(15,13,3,3,'APROVADO',4.50,'2025-11-05 03:41:45.000','2025-11-10 03:41:45.000'),(16,14,4,2,'APROVADO',10.50,'2026-04-25 11:24:00.000','2026-05-01 11:24:00.000'),(17,14,4,3,'DEVOLVIDO_PARA_AJUSTE',12.50,'2025-08-19 17:35:31.000','2025-08-27 17:35:31.000'),(18,14,4,4,'APROVADO',8.50,'2025-06-12 04:12:00.000','2025-06-19 04:12:00.000'),(19,15,5,2,'APROVADO',18.50,'2026-03-12 02:44:09.000','2026-03-15 02:44:09.000'),(20,15,5,3,'AGUARDANDO_AVALIACAO',8.00,'2025-10-28 10:12:00.000','2026-10-03 14:30:50.006'),(21,15,5,4,'APROVADO',7.50,'2025-02-09 10:14:52.000','2025-02-16 10:14:52.000'),(22,16,6,3,'APROVADO',12.00,'2025-08-12 18:57:36.000','2025-08-15 18:57:36.000'),(23,17,7,1,'APROVADO',2.00,'2026-09-17 11:04:26.331','2026-10-03 14:30:50.289'),(24,17,7,2,'APROVADO',3.50,'2026-06-19 15:33:07.000','2026-06-24 15:33:07.000'),(25,17,7,3,'APROVADO',14.00,'2025-08-17 21:34:33.000','2025-08-21 21:34:33.000'),(26,17,7,4,'APROVADO',14.00,'2025-04-15 14:48:28.000','2025-04-19 14:48:28.000'),(27,18,1,2,'RASCUNHO',12.50,'2026-02-06 02:06:43.000','2026-02-06 02:06:43.000'),(28,18,1,3,'APROVADO',15.00,'2025-10-22 09:34:33.000','2025-10-30 09:34:33.000'),(29,18,1,4,'DEVOLVIDO_PARA_AJUSTE',17.50,'2025-05-31 17:26:52.000','2025-06-05 17:26:52.000'),(30,18,8,1,'AGUARDANDO_AVALIACAO',2.50,'2026-09-14 11:04:26.331','2026-09-15 11:04:26.331'),(31,18,8,2,'APROVADO',4.50,'2026-03-09 13:40:48.000','2026-03-14 13:40:48.000'),(32,18,8,3,'APROVADO',5.50,'2025-10-11 15:46:04.000','2025-10-16 15:46:04.000'),(33,18,8,4,'APROVADO',7.00,'2025-02-08 11:21:07.000','2025-02-11 11:21:07.000'),(34,20,10,2,'APROVADO',14.50,'2026-07-09 20:11:02.000','2026-07-13 00:00:00.000'),(35,20,10,3,'APROVADO',4.00,'2025-11-04 21:24:28.000','2025-11-12 21:24:28.000'),(36,20,10,4,'APROVADO',5.50,'2025-03-05 02:49:55.000','2025-03-09 02:49:55.000'),(37,21,1,1,'AGUARDANDO_AVALIACAO',11.00,'2026-09-29 00:59:38.331','2026-10-03 00:59:38.331'),(38,21,1,2,'APROVADO',13.00,'2026-05-31 06:00:00.000','2026-06-04 06:00:00.000'),(39,21,1,3,'APROVADO',16.00,'2025-10-09 00:53:16.000','2025-10-15 00:53:16.000'),(40,21,1,4,'APROVADO',14.00,'2025-07-08 21:17:16.000','2025-07-13 00:00:00.000'),(41,22,2,1,'RASCUNHO',6.00,'2026-09-07 09:09:14.331','2026-09-07 09:09:14.331'),(42,22,2,4,'APROVADO',9.00,'2025-02-14 08:32:38.000','2025-02-22 08:32:38.000'),(43,23,3,1,'AGUARDANDO_AVALIACAO',12.00,'2026-09-14 20:26:02.331','2026-09-19 20:26:02.331'),(44,23,3,2,'RASCUNHO',6.50,'2026-04-04 11:41:16.000','2026-04-04 11:41:16.000'),(45,23,3,3,'AGUARDANDO_AVALIACAO',0.00,'2025-08-24 10:46:33.000','2026-10-03 14:30:39.115'),(46,23,3,4,'DEVOLVIDO_PARA_AJUSTE',14.00,'2025-05-19 15:25:55.000','2025-05-25 15:25:55.000'),(47,24,4,1,'RASCUNHO',13.00,'2026-09-06 14:26:02.331','2026-09-06 14:26:02.331'),(48,24,4,2,'APROVADO',5.50,'2026-04-07 04:33:36.000','2026-04-12 04:33:36.000'),(49,24,4,3,'APROVADO',10.00,'2025-09-22 06:27:21.000','2025-09-24 06:27:21.000'),(50,25,5,2,'APROVADO',4.50,'2026-05-24 21:21:36.000','2026-06-03 21:21:36.000'),(51,25,5,3,'APROVADO',2.50,'2025-10-13 14:55:40.000','2025-10-18 14:55:40.000'),(52,25,5,4,'APROVADO',6.00,'2025-05-10 17:44:09.000','2025-05-18 17:44:09.000'),(53,25,8,3,'DEVOLVIDO_PARA_AJUSTE',12.50,'2025-11-12 05:28:19.000','2025-11-19 05:28:19.000'),(54,26,6,2,'APROVADO',15.00,'2026-06-16 18:51:50.000','2026-06-22 18:51:50.000'),(55,26,6,3,'APROVADO',5.50,'2025-11-24 19:17:45.000','2025-11-29 19:17:45.000'),(56,26,6,4,'APROVADO',14.50,'2025-06-21 05:42:43.000','2025-06-24 05:42:43.000'),(57,27,7,2,'DEVOLVIDO_PARA_AJUSTE',9.50,'2026-02-09 17:52:48.000','2026-02-12 17:52:48.000'),(58,27,7,3,'APROVADO',2.00,'2025-08-26 19:22:04.000','2025-08-31 19:22:04.000'),(59,27,7,4,'APROVADO',10.00,'2025-02-05 07:01:55.000','2025-02-10 07:01:55.000'),(60,28,8,2,'APROVADO',8.00,'2026-05-11 20:26:52.000','2026-05-20 20:26:52.000'),(61,28,8,3,'APROVADO',16.00,'2025-11-06 14:16:48.000','2025-11-12 14:16:48.000'),(62,29,9,2,'APROVADO',15.50,'2026-04-18 19:07:40.000','2026-04-23 19:07:40.000'),(63,29,9,3,'APROVADO',10.50,'2025-10-23 20:09:36.000','2025-10-30 20:09:36.000'),(64,29,9,4,'APROVADO',16.50,'2025-05-03 06:23:02.000','2025-05-09 06:23:02.000'),(65,30,10,4,'DEVOLVIDO_PARA_AJUSTE',22.00,'2025-04-30 13:30:43.000','2025-05-07 13:30:43.000'),(66,31,1,1,'APROVADO',2.00,'2026-09-13 12:45:14.331','2026-10-03 14:30:50.289'),(67,31,1,2,'APROVADO',15.00,'2026-06-07 17:21:07.000','2026-06-11 17:21:07.000'),(68,31,1,3,'APROVADO',19.50,'2025-08-15 12:59:02.000','2025-08-21 12:59:02.000'),(69,31,1,4,'APROVADO',19.00,'2025-04-04 11:41:16.000','2025-04-12 11:41:16.000'),(70,32,2,2,'APROVADO',6.50,'2026-05-27 10:24:57.000','2026-05-30 10:24:57.000'),(71,32,2,3,'APROVADO',5.50,'2025-08-29 10:14:52.000','2025-09-02 10:14:52.000'),(72,32,5,2,'APROVADO',12.50,'2026-05-29 00:34:33.000','2026-06-07 00:34:33.000'),(73,32,5,3,'APROVADO',16.50,'2025-08-23 22:12:00.000','2025-08-26 22:12:00.000'),(74,32,5,4,'APROVADO',12.50,'2025-04-22 18:31:40.000','2025-04-30 18:31:40.000'),(75,33,3,1,'APROVADO',4.00,'2026-09-30 10:06:50.331','2026-10-03 14:26:02.554'),(76,33,3,3,'APROVADO',14.50,'2025-10-22 03:17:16.000','2025-10-25 03:17:16.000'),(77,33,3,4,'AGUARDANDO_AVALIACAO',17.00,'2025-03-22 03:08:38.000','2026-10-03 14:30:48.833'),(78,34,4,2,'APROVADO',3.50,'2026-03-31 16:06:14.000','2026-04-10 16:06:14.000'),(79,34,4,3,'APROVADO',8.50,'2025-11-15 21:30:14.000','2025-11-23 21:30:14.000'),(80,34,4,4,'DEVOLVIDO_PARA_AJUSTE',5.00,'2025-06-28 05:36:57.000','2025-07-05 05:36:57.000'),(81,35,5,1,'APROVADO',13.50,'2026-09-10 19:57:14.331','2026-10-03 14:30:50.289'),(82,35,5,2,'APROVADO',15.50,'2026-07-08 13:39:21.000','2026-07-11 00:00:00.000'),(83,35,5,3,'AGUARDANDO_AVALIACAO',13.50,'2025-09-01 01:07:40.000','2026-10-03 14:30:48.833'),(84,35,5,4,'APROVADO',17.50,'2025-06-25 05:06:43.000','2025-06-30 05:06:43.000'),(85,36,6,2,'APROVADO',10.00,'2026-06-04 01:35:02.000','2026-06-10 01:35:02.000'),(86,36,6,3,'APROVADO',11.50,'2025-08-31 21:59:02.000','2025-09-09 21:59:02.000'),(87,36,6,4,'APROVADO',9.00,'2025-06-30 03:24:28.000','2025-07-06 03:24:28.000'),(88,37,7,2,'APROVADO',15.00,'2026-04-20 09:17:16.000','2026-05-01 09:17:16.000'),(89,37,7,3,'APROVADO',15.50,'2025-09-16 02:41:16.000','2025-09-21 02:41:16.000'),(90,37,7,4,'APROVADO',13.00,'2025-07-08 09:50:24.000','2025-07-18 00:00:00.000'),(91,38,8,3,'DEVOLVIDO_PARA_AJUSTE',4.00,'2025-08-23 03:20:09.000','2025-08-28 03:20:09.000'),(92,38,8,4,'APROVADO',7.00,'2025-05-25 01:10:33.000','2025-05-30 01:10:33.000'),(93,39,2,2,'APROVADO',9.00,'2026-03-20 09:10:04.000','2026-04-01 09:10:04.000'),(94,39,2,3,'APROVADO',17.00,'2025-12-06 17:24:00.000','2025-12-10 17:24:00.000'),(95,39,2,4,'APROVADO',10.00,'2025-02-11 15:40:19.000','2025-02-13 15:40:19.000'),(96,39,9,1,'AGUARDANDO_AVALIACAO',13.50,'2026-09-27 16:35:38.331','2026-10-03 14:30:50.370'),(97,39,9,2,'APROVADO',5.50,'2026-04-29 03:10:04.000','2026-05-07 03:10:04.000'),(98,39,9,3,'APROVADO',11.50,'2025-11-29 15:37:26.000','2025-12-06 15:37:26.000'),(99,39,9,4,'APROVADO',11.50,'2025-06-19 04:06:14.000','2025-07-01 04:06:14.000'),(100,40,10,2,'DEVOLVIDO_PARA_AJUSTE',5.50,'2026-04-23 09:47:31.000','2026-05-01 09:47:31.000'),(101,40,10,3,'APROVADO',2.50,'2025-11-03 13:58:04.000','2025-11-09 13:58:04.000'),(102,40,10,4,'APROVADO',12.50,'2025-03-18 03:44:38.000','2025-03-23 03:44:38.000'),(103,41,1,2,'APROVADO',16.50,'2026-03-19 06:27:21.000','2026-03-25 06:27:21.000'),(104,41,1,4,'AGUARDANDO_AVALIACAO',11.00,'2025-05-22 15:56:09.000','2026-10-03 14:30:48.833');
/*!40000 ALTER TABLE `Relatorio` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `trg_controle_fluxo_situacao` BEFORE UPDATE ON `Relatorio` FOR EACH ROW BEGIN 	
    IF NEW.situacao <> OLD.situacao THEN 	  
        IF NOT ( 			
            (OLD.situacao = 'RASCUNHO' AND NEW.situacao = 'AGUARDANDO_AVALIACAO') 				
            OR  			
            (OLD.situacao = 'DEVOLVIDO_PARA_AJUSTE' AND NEW.situacao = 'AGUARDANDO_AVALIACAO') 				
            OR  			
            (OLD.situacao = 'AGUARDANDO_AVALIACAO' AND NEW.situacao = 'APROVADO') 				
            OR  			
            (OLD.situacao = 'AGUARDANDO_AVALIACAO' AND NEW.situacao = 'DEVOLVIDO_PARA_AJUSTE') 		
        ) THEN 		    
            SIGNAL SQLSTATE '45000' 		  	
            SET MESSAGE_TEXT = 'Transicao de situacao invalida para o fluxo do relatorio.'; 	
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `trg_auditoria_mudanca_situacao` AFTER UPDATE ON `Relatorio` FOR EACH ROW BEGIN
    DECLARE v_coord INT;

    IF NEW.situacao <> OLD.situacao THEN
        IF NEW.situacao = 'AGUARDANDO_AVALIACAO' THEN
            INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId)
            VALUES (NEW.id, 'SUBMISSAO', NEW.docenteId);
        ELSE
            SELECT MIN(coordenadorId) INTO v_coord
              FROM VinculoCoordenadorCurso
             WHERE cursoId = NEW.cursoId AND periodoLetivoId = NEW.periodoLetivoId;

            IF NEW.situacao = 'APROVADO' THEN
                INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId)
                VALUES (NEW.id, 'APROVACAO', v_coord);
            ELSE
                INSERT INTO EventoAuditoria (relatorioId, tipo, usuarioId, justificativa)
                VALUES (NEW.id, 'DEVOLUCAO', v_coord, 'Devolvido pelo coordenador para ajuste.');
            END IF;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `TipoAtividade`
--

DROP TABLE IF EXISTS `TipoAtividade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoAtividade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(255) NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `TipoAtividade_descricao_key` (`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TipoAtividade`
--

LOCK TABLES `TipoAtividade` WRITE;
/*!40000 ALTER TABLE `TipoAtividade` DISABLE KEYS */;
INSERT INTO `TipoAtividade` VALUES (1,'Orientação de TCC',1),(2,'Supervisão de Estágio',1),(3,'Participação em NBE',1);
/*!40000 ALTER TABLE `TipoAtividade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `entraOid` varchar(255) DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criadoEm` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Usuario_email_key` (`email`),
  UNIQUE KEY `Usuario_entraOid_key` (`entraOid`),
  CONSTRAINT `chk_usuario_identificacao` CHECK ((regexp_like(`email`,_utf8mb4'^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$',_utf8mb4'c') and (trim(`nome`) <> _utf8mb4'')))
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES (1,'Helena Vasconcelos','helena@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.345'),(2,'Cláudia Ferrari','claudia@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.345'),(3,'Marcos Rinaldi','marcos@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.345'),(4,'Paulo Tavares','paulo@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.345'),(5,'Henrique Ferraz','coordenador01@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.357'),(6,'Carla Machado','coordenador02@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.357'),(7,'João Duarte','coordenador03@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.357'),(8,'Elaine Junqueira','coordenador04@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.357'),(9,'Leonardo Barros','coordenador05@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.357'),(12,'Sabrina Winter','docente001@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(13,'Beatriz Queiroz','docente002@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(14,'Patrícia Zanetti','docente003@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(15,'Wagner Salgado','docente004@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(16,'Nelson Bezerra','docente005@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(17,'Tiago Valente','docente006@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(18,'Cauê Pimenta','docente007@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(19,'Rafael Xavier','docente008@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(20,'Yasmin Ramalho','docente009@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(21,'Otávio Andrade','docente010@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(22,'Vanessa Teodoro','docente011@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(23,'Mariana Pimenta','docente012@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(24,'Sabrina Xavier','docente013@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(25,'Beatriz Ramalho','docente014@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(26,'Patrícia Andrade','docente015@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(27,'Wagner Teodoro','docente016@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(28,'Nelson Oliveira','docente017@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(29,'Tiago Winter','docente018@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(30,'Cauê Queiroz','docente019@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(31,'Rafael Zanetti','docente020@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(32,'Yasmin Salgado','docente021@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(33,'Otávio Bezerra','docente022@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(34,'Vanessa Valente','docente023@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(35,'Mariana Queiroz','docente024@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(36,'Sabrina Zanetti','docente025@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(37,'Beatriz Salgado','docente026@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(38,'Patrícia Bezerra','docente027@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(39,'Wagner Valente','docente028@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(40,'Nelson Pimenta','docente029@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(41,'Tiago Xavier','docente030@baraodemaua.br',NULL,1,'2026-10-03 14:26:02.365'),(42,'Teste Regra 5 - valido','novo.usuario@baraodemaua.br',NULL,1,'2026-10-03 14:28:17.692');
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VinculoCoordenadorCurso`
--

DROP TABLE IF EXISTS `VinculoCoordenadorCurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VinculoCoordenadorCurso` (
  `id` int NOT NULL AUTO_INCREMENT,
  `coordenadorId` int NOT NULL,
  `cursoId` int NOT NULL,
  `periodoLetivoId` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `VinculoCoordenadorCurso_coord_curso_periodo_key` (`coordenadorId`,`cursoId`,`periodoLetivoId`),
  KEY `VinculoCoordenadorCurso_cursoId_fkey` (`cursoId`),
  KEY `VinculoCoordenadorCurso_periodoLetivoId_fkey` (`periodoLetivoId`),
  CONSTRAINT `VinculoCoordenadorCurso_coordenadorId_fkey` FOREIGN KEY (`coordenadorId`) REFERENCES `Coordenador` (`usuarioId`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoCoordenadorCurso_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoCoordenadorCurso_periodoLetivoId_fkey` FOREIGN KEY (`periodoLetivoId`) REFERENCES `PeriodoLetivo` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VinculoCoordenadorCurso`
--

LOCK TABLES `VinculoCoordenadorCurso` WRITE;
/*!40000 ALTER TABLE `VinculoCoordenadorCurso` DISABLE KEYS */;
INSERT INTO `VinculoCoordenadorCurso` VALUES (11,2,1,1),(8,2,1,2),(5,2,1,3),(2,2,1,4),(10,3,2,1),(7,3,2,2),(4,3,2,3),(1,3,2,4),(12,4,3,1),(9,4,3,2),(6,4,3,3),(3,4,3,4),(16,5,4,1),(17,5,4,2),(18,5,4,3),(19,5,4,4),(36,5,9,1),(37,5,9,2),(38,5,9,3),(39,5,9,4),(20,6,5,1),(21,6,5,2),(22,6,5,3),(23,6,5,4),(40,6,10,1),(41,6,10,2),(42,6,10,3),(43,6,10,4),(24,7,6,1),(25,7,6,2),(26,7,6,3),(27,7,6,4),(28,8,7,1),(29,8,7,2),(30,8,7,3),(31,8,7,4),(32,9,8,1),(33,9,8,2),(34,9,8,3),(35,9,8,4);
/*!40000 ALTER TABLE `VinculoCoordenadorCurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VinculoDocenteCurso`
--

DROP TABLE IF EXISTS `VinculoDocenteCurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VinculoDocenteCurso` (
  `id` int NOT NULL AUTO_INCREMENT,
  `docenteId` int NOT NULL,
  `cursoId` int NOT NULL,
  `periodoLetivoId` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `VinculoDocenteCurso_doc_curso_periodo_key` (`docenteId`,`cursoId`,`periodoLetivoId`),
  KEY `VinculoDocenteCurso_cursoId_fkey` (`cursoId`),
  KEY `VinculoDocenteCurso_periodoLetivoId_fkey` (`periodoLetivoId`),
  CONSTRAINT `VinculoDocenteCurso_cursoId_fkey` FOREIGN KEY (`cursoId`) REFERENCES `Curso` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoDocenteCurso_docenteId_fkey` FOREIGN KEY (`docenteId`) REFERENCES `Docente` (`usuarioId`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `VinculoDocenteCurso_periodoLetivoId_fkey` FOREIGN KEY (`periodoLetivoId`) REFERENCES `PeriodoLetivo` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VinculoDocenteCurso`
--

LOCK TABLES `VinculoDocenteCurso` WRITE;
/*!40000 ALTER TABLE `VinculoDocenteCurso` DISABLE KEYS */;
INSERT INTO `VinculoDocenteCurso` VALUES (11,1,1,1),(8,1,1,2),(5,1,1,3),(2,1,1,4),(10,1,2,1),(7,1,2,2),(4,1,2,3),(1,1,2,4),(12,4,3,1),(9,4,3,2),(6,4,3,3),(3,4,3,4),(16,12,2,1),(17,12,2,2),(18,12,2,3),(19,12,2,4),(20,13,3,1),(21,13,3,2),(22,13,3,3),(23,13,3,4),(24,14,4,1),(25,14,4,2),(26,14,4,3),(27,14,4,4),(28,15,5,1),(29,15,5,2),(30,15,5,3),(31,15,5,4),(32,16,6,1),(33,16,6,2),(34,16,6,3),(35,16,6,4),(36,17,7,1),(37,17,7,2),(38,17,7,3),(39,17,7,4),(40,18,1,1),(42,18,1,2),(44,18,1,3),(46,18,1,4),(41,18,8,1),(43,18,8,2),(45,18,8,3),(47,18,8,4),(48,19,9,1),(49,19,9,2),(50,19,9,3),(51,19,9,4),(52,20,10,1),(53,20,10,2),(54,20,10,3),(55,20,10,4),(56,21,1,1),(57,21,1,2),(58,21,1,3),(59,21,1,4),(60,22,2,1),(61,22,2,2),(62,22,2,3),(63,22,2,4),(64,23,3,1),(65,23,3,2),(66,23,3,3),(67,23,3,4),(68,24,4,1),(69,24,4,2),(70,24,4,3),(71,24,4,4),(72,25,5,1),(74,25,5,2),(76,25,5,3),(78,25,5,4),(73,25,8,1),(75,25,8,2),(77,25,8,3),(79,25,8,4),(80,26,6,1),(81,26,6,2),(82,26,6,3),(83,26,6,4),(84,27,7,1),(85,27,7,2),(86,27,7,3),(87,27,7,4),(88,28,8,1),(89,28,8,2),(90,28,8,3),(91,28,8,4),(92,29,9,1),(93,29,9,2),(94,29,9,3),(95,29,9,4),(96,30,10,1),(97,30,10,2),(98,30,10,3),(99,30,10,4),(100,31,1,1),(101,31,1,2),(102,31,1,3),(103,31,1,4),(104,32,2,1),(106,32,2,2),(108,32,2,3),(110,32,2,4),(105,32,5,1),(107,32,5,2),(109,32,5,3),(111,32,5,4),(112,33,3,1),(113,33,3,2),(114,33,3,3),(115,33,3,4),(116,34,4,1),(117,34,4,2),(118,34,4,3),(119,34,4,4),(120,35,5,1),(121,35,5,2),(122,35,5,3),(123,35,5,4),(124,36,6,1),(125,36,6,2),(126,36,6,3),(127,36,6,4),(128,37,7,1),(129,37,7,2),(130,37,7,3),(131,37,7,4),(132,38,8,1),(133,38,8,2),(134,38,8,3),(135,38,8,4),(136,39,2,1),(138,39,2,2),(140,39,2,3),(142,39,2,4),(137,39,9,1),(139,39,9,2),(141,39,9,3),(143,39,9,4),(144,40,10,1),(145,40,10,2),(146,40,10,3),(147,40,10,4),(148,41,1,1),(149,41,1,2),(150,41,1,3),(151,41,1,4);
/*!40000 ALTER TABLE `VinculoDocenteCurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_relatorios_aprovados`
--

DROP TABLE IF EXISTS `vw_relatorios_aprovados`;
/*!50001 DROP VIEW IF EXISTS `vw_relatorios_aprovados`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_relatorios_aprovados` AS SELECT 
 1 AS `relatorio`,
 1 AS `docente`,
 1 AS `curso`,
 1 AS `periodo`,
 1 AS `carga_horaria`,
 1 AS `aprovado_em`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'rsha_teste'
--

--
-- Dumping routines for database 'rsha_teste'
--

--
-- Current Database: `rsha_teste`
--

USE `rsha_teste`;

--
-- Final view structure for view `vw_relatorios_aprovados`
--

/*!50001 DROP VIEW IF EXISTS `vw_relatorios_aprovados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_relatorios_aprovados` AS select `r`.`id` AS `relatorio`,`u`.`nome` AS `docente`,`c`.`nome` AS `curso`,concat(`p`.`ano`,'/',`p`.`semestre`) AS `periodo`,`r`.`cargaHorariaTotal` AS `carga_horaria`,`a`.`aprovado_em` AS `aprovado_em` from ((((`Relatorio` `r` join `Usuario` `u` on((`u`.`id` = `r`.`docenteId`))) join `Curso` `c` on((`c`.`id` = `r`.`cursoId`))) join `PeriodoLetivo` `p` on((`p`.`id` = `r`.`periodoLetivoId`))) join (select `EventoAuditoria`.`relatorioId` AS `relatorioId`,max(`EventoAuditoria`.`ocorridoEm`) AS `aprovado_em` from `EventoAuditoria` where (`EventoAuditoria`.`tipo` = 'APROVACAO') group by `EventoAuditoria`.`relatorioId`) `a` on((`a`.`relatorioId` = `r`.`id`))) where (`r`.`situacao` = 'APROVADO') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-03 14:37:58
