CREATE DATABASE  IF NOT EXISTS `roca_maya` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `roca_maya`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: roca_maya
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tbl_citas`
--

DROP TABLE IF EXISTS `tbl_citas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_citas` (
  `ID_CITA` int NOT NULL AUTO_INCREMENT,
  `ID_PACIENTE` int NOT NULL,
  `ID_DOCTOR` int NOT NULL,
  `FECHA_CITA` datetime NOT NULL,
  `FECHA_FIN_ESTIMADA` datetime DEFAULT NULL,
  `DURACION_ESTIMADA_MIN` int DEFAULT '30',
  `ESTADO` enum('PROGRAMADA','CONFIRMADA','PRECLINICA','CONSULTA_MEDICA','FINALIZADA','CANCELADA','NO_ASISTIO') DEFAULT 'PROGRAMADA',
  `MOTIVO_CONSULTA` text,
  `ID_USUARIOCREADOR` int NOT NULL,
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  `OBSERVACIONES` text,
  `PRIORIDAD` enum('NORMAL','URGENTE','ALTA') DEFAULT 'NORMAL',
  `TIPO_CITA` enum('PRIMERA_VEZ','CONTROL','EMERGENCIA','PROCEDIMIENTO') DEFAULT 'PRIMERA_VEZ',
  `CANAL_REGISTRO` enum('PRESENCIAL','TELEFONO','WEB','MOVIL','API') DEFAULT 'PRESENCIAL',
  PRIMARY KEY (`ID_CITA`),
  KEY `ID_USUARIOCREADOR` (`ID_USUARIOCREADOR`),
  KEY `idx_citas_paciente` (`ID_PACIENTE`),
  KEY `idx_citas_doctor` (`ID_DOCTOR`),
  KEY `idx_citas_estado` (`ESTADO`),
  KEY `idx_citas_fecha` (`FECHA_CITA`),
  KEY `idx_citas_creacion` (`FECHA_CREACION`),
  KEY `idx_citas_modificacion` (`FECHA_MODIFICACION`),
  CONSTRAINT `tbl_citas_ibfk_1` FOREIGN KEY (`ID_PACIENTE`) REFERENCES `tbl_paciente` (`ID_PACIENTE`),
  CONSTRAINT `tbl_citas_ibfk_2` FOREIGN KEY (`ID_DOCTOR`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`),
  CONSTRAINT `tbl_citas_ibfk_3` FOREIGN KEY (`ID_USUARIOCREADOR`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_citas`
--

LOCK TABLES `tbl_citas` WRITE;
/*!40000 ALTER TABLE `tbl_citas` DISABLE KEYS */;
INSERT INTO `tbl_citas` VALUES (1,1,2,'2024-01-15 09:00:00','2024-01-15 09:30:00',30,'FINALIZADA','CONTROL DE HIPERTENSIÓN Y REVISIÓN DE MEDICACIÓN ACTUAL. PACIENTE REFIERE CEFALEA OCASIONAL.',4,'2025-11-26 23:37:20','RECEP.ANA','2025-11-26 23:37:20','DR.GARCIA','PACIENTE PUNTUAL, TRAE EXAMENES ANTERIORES','NORMAL','CONTROL','PRESENCIAL'),(2,2,2,'2025-11-28 03:51:00','2025-11-28 04:06:00',15,'FINALIZADA',NULL,1,'2025-11-27 00:51:38','SISTEMA','2025-11-27 00:52:35','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(3,2,2,'2025-11-28 02:58:00','2025-11-28 03:13:00',15,'FINALIZADA',NULL,1,'2025-11-27 00:54:12','SISTEMA','2025-11-27 00:55:16','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(4,1,2,'2025-11-27 01:14:00','2025-11-27 01:29:00',15,'FINALIZADA',NULL,1,'2025-11-27 01:10:20','SISTEMA','2025-11-27 01:11:32','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(5,2,2,'2025-11-28 04:18:00','2025-11-28 04:33:00',15,'FINALIZADA',NULL,1,'2025-11-27 01:18:55','SISTEMA','2025-11-27 01:20:04','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(6,2,2,'2025-11-28 05:25:00','2025-11-28 05:40:00',15,'FINALIZADA',NULL,1,'2025-11-27 01:21:47','SISTEMA','2025-11-27 01:23:14','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(7,2,2,'2025-11-28 05:24:00','2025-11-28 05:39:00',15,'FINALIZADA',NULL,1,'2025-11-27 01:24:38','SISTEMA','2025-11-27 01:25:51','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(8,2,2,'2025-11-28 04:28:00','2025-11-28 04:43:00',15,'FINALIZADA',NULL,1,'2025-11-27 01:28:32','SISTEMA','2025-11-27 01:29:30','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(9,1,2,'2025-11-28 05:43:00','2025-11-28 05:58:00',15,'FINALIZADA',NULL,1,'2025-11-27 01:44:10','SISTEMA','2025-11-27 01:46:00','SISTEMA',NULL,'NORMAL','CONTROL','PRESENCIAL'),(10,1,2,'2025-11-28 05:59:00','2025-11-28 06:14:00',15,'FINALIZADA',NULL,1,'2025-11-27 01:59:39','SISTEMA','2025-11-27 02:05:59','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(11,2,2,'2025-11-28 06:03:00','2025-11-28 06:18:00',15,'FINALIZADA',NULL,1,'2025-11-27 02:03:27','SISTEMA','2025-11-27 02:47:24','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(12,1,2,'2025-11-28 16:33:00','2025-11-28 16:48:00',15,'FINALIZADA',NULL,1,'2025-11-27 12:33:55','SISTEMA','2025-11-27 12:35:31','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(13,1,2,'2025-11-28 14:15:00','2025-11-28 14:30:00',15,'FINALIZADA',NULL,1,'2025-11-27 14:10:26','SISTEMA','2025-11-27 14:13:04','SISTEMA',NULL,'NORMAL','CONTROL','PRESENCIAL'),(14,1,2,'2025-11-28 18:17:00','2025-11-28 18:32:00',15,'FINALIZADA',NULL,1,'2025-11-27 14:17:09','SISTEMA','2025-11-27 14:18:15','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(15,1,2,'2025-11-27 18:20:00','2025-11-27 18:35:00',15,'FINALIZADA',NULL,1,'2025-11-27 14:20:59','SISTEMA','2025-11-27 14:23:13','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(16,1,2,'2025-11-28 17:28:00','2025-11-28 17:43:00',15,'FINALIZADA',NULL,1,'2025-11-27 14:28:09','SISTEMA','2025-11-27 14:29:13','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(17,2,2,'2025-11-29 17:36:00','2025-11-29 17:51:00',15,'FINALIZADA',NULL,1,'2025-11-27 14:36:05','SISTEMA','2025-11-27 14:37:25','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(18,2,2,'2025-11-30 19:40:00','2025-11-30 19:55:00',15,'FINALIZADA',NULL,1,'2025-11-27 15:40:48','SISTEMA','2025-11-27 15:41:59','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(19,1,2,'2025-12-01 20:05:00','2025-12-01 20:20:00',15,'FINALIZADA',NULL,1,'2025-11-27 16:05:15','SISTEMA','2025-11-27 16:07:02','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(20,1,2,'2025-12-01 17:24:00','2025-12-01 17:39:00',15,'FINALIZADA',NULL,1,'2025-11-27 16:24:04','SISTEMA','2025-11-27 16:25:11','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(21,1,2,'2025-12-01 18:26:00','2025-12-01 18:41:00',15,'FINALIZADA',NULL,1,'2025-11-27 16:26:07','SISTEMA','2025-11-27 16:27:10','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(22,2,2,'2025-11-30 20:19:00','2025-11-30 20:34:00',15,'FINALIZADA',NULL,1,'2025-11-27 17:19:11','SISTEMA','2025-11-27 17:20:35','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(23,1,2,'2025-11-29 21:33:00','2025-11-29 21:48:00',15,'FINALIZADA',NULL,1,'2025-11-27 19:31:11','SISTEMA','2025-11-27 19:32:15','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL'),(24,1,2,'2025-11-29 18:31:00','2025-11-29 18:46:00',15,'FINALIZADA',NULL,1,'2025-11-28 14:31:44','SISTEMA','2025-11-28 14:32:52','SISTEMA',NULL,'NORMAL','PRIMERA_VEZ','PRESENCIAL');
/*!40000 ALTER TABLE `tbl_citas` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_CITAS_INSERT` AFTER INSERT ON `tbl_citas` FOR EACH ROW BEGIN
    CALL SP_REGISTRAR_BITACORA(
        COALESCE(NEW.ID_USUARIOCREADOR, 1),
        'CREACION_CITA',
        CONCAT('Cita creada para paciente ID: ', NEW.ID_PACIENTE, ' con doctor ID: ', NEW.ID_DOCTOR, ' - ', NEW.ESTADO),
        'CITAS',
        NEW.ID_CITA,
        'TBL_CITAS',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_CITAS_UPDATE` AFTER UPDATE ON `tbl_citas` FOR EACH ROW BEGIN
    IF OLD.ESTADO != NEW.ESTADO THEN
        CALL SP_REGISTRAR_BITACORA(
            COALESCE((SELECT ID_USUARIO FROM TBL_MS_USUARIO WHERE USUARIO = COALESCE(NEW.USUARIO_MODIFICACION, 'SISTEMA')), 1),
            'CAMBIO_ESTADO_CITA',
            CONCAT('Cita ID ', NEW.ID_CITA, ' cambió de ', OLD.ESTADO, ' a ', NEW.ESTADO),
            'CITAS',
            NEW.ID_CITA,
            'TBL_CITAS',
            NULL, NULL, 'EXITO', NULL,
            'TRIGGER'
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_consulta_medica`
--

DROP TABLE IF EXISTS `tbl_consulta_medica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_consulta_medica` (
  `ID_CONSULTA` int NOT NULL AUTO_INCREMENT,
  `ID_CITA` int NOT NULL,
  `ID_PACIENTE` int NOT NULL,
  `ID_DOCTOR` int NOT NULL,
  `MOTIVO_CONSULTA` text,
  `SINTOMAS` json DEFAULT NULL,
  `EXAMEN_FISICO` json DEFAULT NULL,
  `DIAGNOSTICO_PRINCIPAL` text,
  `CODIGO_CIE10_PRINCIPAL` varchar(10) DEFAULT NULL,
  `DIAGNOSTICO_SECUNDARIO` text,
  `CODIGO_CIE10_SECUNDARIO` varchar(10) DEFAULT NULL,
  `TRATAMIENTO` text,
  `RECOMENDACIONES` text,
  `OBSERVACIONES` text,
  `FECHA_CONSULTA` datetime DEFAULT CURRENT_TIMESTAMP,
  `PROXIMA_CITA_RECOMENDADA` date DEFAULT NULL,
  `TIPO_CONSULTA` enum('GENERAL','ESPECIALIDAD','CONTROL','EMERGENCIA') DEFAULT 'GENERAL',
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_CONSULTA`),
  UNIQUE KEY `ID_CITA` (`ID_CITA`),
  KEY `ID_DOCTOR` (`ID_DOCTOR`),
  KEY `idx_consulta_cita` (`ID_CITA`),
  KEY `idx_consulta_paciente` (`ID_PACIENTE`),
  KEY `idx_consulta_fecha` (`FECHA_CONSULTA`),
  CONSTRAINT `tbl_consulta_medica_ibfk_1` FOREIGN KEY (`ID_CITA`) REFERENCES `tbl_citas` (`ID_CITA`) ON DELETE CASCADE,
  CONSTRAINT `tbl_consulta_medica_ibfk_2` FOREIGN KEY (`ID_PACIENTE`) REFERENCES `tbl_paciente` (`ID_PACIENTE`),
  CONSTRAINT `tbl_consulta_medica_ibfk_3` FOREIGN KEY (`ID_DOCTOR`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_consulta_medica`
--

LOCK TABLES `tbl_consulta_medica` WRITE;
/*!40000 ALTER TABLE `tbl_consulta_medica` DISABLE KEYS */;
INSERT INTO `tbl_consulta_medica` VALUES (1,1,1,2,'CONTROL DE HIPERTENSIÓN ARTERIAL','[\"CEFALEA OCCIPITAL\", \"VISIÓN BORROSA OCASIONAL\", \"CANSANCIO\"]','{\"abdomen\": \"BLANDO, NO DOLOROSO\", \"cardiopulmonar\": \"RITMO CARDÍACO REGULAR\", \"cabeza_y_cuello\": \"NORMOCÉFALO\"}','HIPERTENSIÓN ARTERIAL ESENCIAL NO CONTROLADA','I10','CEFALEA TENSIONAL','G44.2','AJUSTAR DOSIS DE LOSARTAN A 100MG DIARIOS. AGREGAR HIDROCLOROTIAZIDA 12.5MG. CONTROL DE PRESIÓN ARTERIAL EN CASA.','DIETA BAJA EN SODIO. EJERCICIO AERÓBICO 30 MINUTOS DIARIOS. REDUCIR CONSUMO OF CAFÉ. CONTROL DE ESTRÉS.','PACIENTE CON HIPERTENSIÓN NO CONTROLADA A PESAR DE TRATAMIENTO ACTUAL. SE AJUSTA MEDICACIÓN Y SE SOLICITAN EXÁMENES.','2025-11-26 23:37:20','2024-02-15','CONTROL','DR.GARCIA','DR.GARCIA'),(2,2,2,2,'y','[\"h\"]','[\"h\"]','j',NULL,NULL,NULL,'j',NULL,NULL,'2025-11-27 00:52:35',NULL,'GENERAL','SISTEMA',NULL),(3,3,2,2,'uuu','[\"kkk\"]','[\"ooo\"]','ooo',NULL,NULL,NULL,'ooo','hui',NULL,'2025-11-27 00:55:16',NULL,'GENERAL','SISTEMA',NULL),(4,4,1,2,'ig','[\"i\"]','[\"i\"]','h',NULL,NULL,NULL,'k','u',NULL,'2025-11-27 01:11:32',NULL,'GENERAL','SISTEMA',NULL),(5,5,2,2,'u','[\"i\"]','[\"i\"]','i',NULL,NULL,NULL,'o','i',NULL,'2025-11-27 01:20:04',NULL,'GENERAL','SISTEMA',NULL),(6,6,2,2,'u','[\"i\"]','[\"o\"]','o',NULL,NULL,NULL,'o','o',NULL,'2025-11-27 01:23:14',NULL,'GENERAL','SISTEMA',NULL),(7,7,2,2,'i','[\"u\"]','[]','i',NULL,NULL,NULL,'k','k',NULL,'2025-11-27 01:25:51',NULL,'GENERAL','SISTEMA',NULL),(8,8,2,2,'j','[\"j\"]','[\"o\"]','k',NULL,NULL,NULL,'k',NULL,NULL,'2025-11-27 01:29:30',NULL,'GENERAL','SISTEMA',NULL),(9,9,1,2,'y','[\"i\"]','[\"o\"]','i',NULL,NULL,NULL,'o','i',NULL,'2025-11-27 01:46:00',NULL,'ESPECIALIDAD','SISTEMA',NULL),(10,10,1,2,'dolor de cabeza','[\"sdds\"]','[\"ijoj\"]','non',NULL,NULL,NULL,'ll','jj',NULL,'2025-11-27 02:05:59',NULL,'ESPECIALIDAD','SISTEMA',NULL),(11,11,2,2,'dolor de cabeza','[\"j0\"]','[\"ijo\"]','kp',NULL,NULL,NULL,'pk','jp',NULL,'2025-11-27 02:47:24',NULL,'EMERGENCIA','SISTEMA',NULL),(12,12,1,2,'j','[\"o\"]','[\"o\"]','o',NULL,NULL,NULL,'o','o',NULL,'2025-11-27 12:35:31',NULL,'GENERAL','SISTEMA',NULL),(13,13,1,2,'e','[\"w\"]','[\"i\"]','o',NULL,NULL,NULL,'o','o',NULL,'2025-11-27 14:13:04',NULL,'CONTROL','SISTEMA',NULL),(14,14,1,2,'rr','[\"rt\"]','[\"rt\"]','e',NULL,NULL,NULL,'e','d',NULL,'2025-11-27 14:18:15',NULL,'GENERAL','SISTEMA',NULL),(15,15,1,2,'uu','[\"oo\"]','[\"oo\"]','i',NULL,NULL,NULL,'p','o',NULL,'2025-11-27 14:23:13',NULL,'EMERGENCIA','SISTEMA',NULL),(16,16,1,2,'eer','[\"er\"]','[\"fg\"]','fg',NULL,NULL,NULL,'fg','rt',NULL,'2025-11-27 14:29:13',NULL,'GENERAL','SISTEMA',NULL),(17,17,2,2,'ii','[\"ii\"]','[\"oo\"]','jj',NULL,NULL,NULL,'uu','i',NULL,'2025-11-27 14:37:25',NULL,'EMERGENCIA','SISTEMA',NULL),(18,18,2,2,'oo','[\"o\"]','[\"k\"]','i',NULL,NULL,NULL,'4','r',NULL,'2025-11-27 15:41:59',NULL,'CONTROL','SISTEMA',NULL),(19,19,1,2,'k','[\"j\"]','[\"o\"]','o',NULL,NULL,NULL,'o','o',NULL,'2025-11-27 16:07:02',NULL,'EMERGENCIA','SISTEMA',NULL),(20,20,1,2,'jj','[\"k\"]','[\"oo\"]','kk',NULL,NULL,NULL,'pp','ll',NULL,'2025-11-27 16:25:11',NULL,'CONTROL','SISTEMA',NULL),(21,21,1,2,'kk','[\"kk\"]','[\"ll\"]','kk',NULL,NULL,NULL,'kk','ll',NULL,'2025-11-27 16:27:10',NULL,'GENERAL','SISTEMA',NULL),(22,22,2,2,'jj','[\"kk\"]','[\"l\"]','k',NULL,NULL,NULL,'l','l',NULL,'2025-11-27 17:20:35',NULL,'GENERAL','SISTEMA',NULL),(23,23,1,2,'j','[\"k\"]','[\"l\"]','j',NULL,NULL,NULL,'l','l',NULL,'2025-11-27 19:32:15',NULL,'GENERAL','SISTEMA',NULL),(24,24,1,2,'hii','[\"oo\"]','[\"ll\"]','kk',NULL,NULL,NULL,'oo','ll',NULL,'2025-11-28 14:32:52',NULL,'GENERAL','SISTEMA',NULL);
/*!40000 ALTER TABLE `tbl_consulta_medica` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_CONSULTAS_INSERT` AFTER INSERT ON `tbl_consulta_medica` FOR EACH ROW BEGIN
    CALL SP_REGISTRAR_BITACORA(
        COALESCE(NEW.ID_DOCTOR, 1),
        'REGISTRO_CONSULTA',
        CONCAT('Consulta médica registrada para paciente ID: ', NEW.ID_PACIENTE, ' - Diagnóstico: ', COALESCE(LEFT(NEW.DIAGNOSTICO_PRINCIPAL, 50), 'SIN DIAGNÓSTICO')),
        'CONSULTAS',
        NEW.ID_CONSULTA,
        'TBL_CONSULTA_MEDICA',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_detalle_factura`
--

DROP TABLE IF EXISTS `tbl_detalle_factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_detalle_factura` (
  `ID_DETALLE_FACTURA` int NOT NULL AUTO_INCREMENT,
  `ID_FACTURA` int NOT NULL,
  `ID_SERVICIO` int DEFAULT NULL,
  `DESCRIPCION_SERVICIO` varchar(255) DEFAULT NULL,
  `CANTIDAD` int NOT NULL DEFAULT '1',
  `PRECIO_UNITARIO` decimal(10,2) DEFAULT NULL,
  `SUBTOTAL` decimal(12,2) GENERATED ALWAYS AS ((`CANTIDAD` * `PRECIO_UNITARIO`)) STORED,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_DETALLE_FACTURA`),
  KEY `ID_SERVICIO` (`ID_SERVICIO`),
  KEY `idx_detalle_factura` (`ID_FACTURA`),
  CONSTRAINT `tbl_detalle_factura_ibfk_1` FOREIGN KEY (`ID_FACTURA`) REFERENCES `tbl_factura` (`ID_FACTURA`) ON DELETE CASCADE,
  CONSTRAINT `tbl_detalle_factura_ibfk_2` FOREIGN KEY (`ID_SERVICIO`) REFERENCES `tbl_servicios_medicos` (`ID_SERVICIO`),
  CONSTRAINT `tbl_detalle_factura_chk_1` CHECK ((`CANTIDAD` >= 1)),
  CONSTRAINT `tbl_detalle_factura_chk_2` CHECK ((`PRECIO_UNITARIO` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_detalle_factura`
--

LOCK TABLES `tbl_detalle_factura` WRITE;
/*!40000 ALTER TABLE `tbl_detalle_factura` DISABLE KEYS */;
INSERT INTO `tbl_detalle_factura` (`ID_DETALLE_FACTURA`, `ID_FACTURA`, `ID_SERVICIO`, `DESCRIPCION_SERVICIO`, `CANTIDAD`, `PRECIO_UNITARIO`, `USUARIO_CREACION`, `USUARIO_MODIFICACION`) VALUES (1,1,2,'CONSULTA CARDIOLOGÍA - DR. GARCÍA',1,800.00,'RECEP.ANA','RECEP.ANA');
/*!40000 ALTER TABLE `tbl_detalle_factura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_doctor_especialidad`
--

DROP TABLE IF EXISTS `tbl_doctor_especialidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_doctor_especialidad` (
  `ID_DOCTOR_ESPECIALIDAD` int NOT NULL AUTO_INCREMENT,
  `ID_DOCTOR` int NOT NULL,
  `ID_ESPECIALIDAD` int NOT NULL,
  `FECHA_ASIGNACION` date DEFAULT (curdate()),
  `ESTADO` enum('ACTIVA','INACTIVA') DEFAULT 'ACTIVA',
  `ES_PRIMARIA` tinyint(1) DEFAULT '0',
  `ANIOS_EXPERIENCIA` int DEFAULT '0',
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_DOCTOR_ESPECIALIDAD`),
  UNIQUE KEY `UNIQUE_TBL_DOCTOR_ESPECIALIDAD` (`ID_DOCTOR`,`ID_ESPECIALIDAD`),
  KEY `ID_ESPECIALIDAD` (`ID_ESPECIALIDAD`),
  KEY `idx_doctor_especialidad_estado` (`ESTADO`),
  CONSTRAINT `tbl_doctor_especialidad_ibfk_1` FOREIGN KEY (`ID_DOCTOR`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`) ON DELETE CASCADE,
  CONSTRAINT `tbl_doctor_especialidad_ibfk_2` FOREIGN KEY (`ID_ESPECIALIDAD`) REFERENCES `tbl_especialidades` (`ID_ESPECIALIDAD`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_doctor_especialidad`
--

LOCK TABLES `tbl_doctor_especialidad` WRITE;
/*!40000 ALTER TABLE `tbl_doctor_especialidad` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_doctor_especialidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_especialidades`
--

DROP TABLE IF EXISTS `tbl_especialidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_especialidades` (
  `ID_ESPECIALIDAD` int NOT NULL AUTO_INCREMENT,
  `NOMBRE_ESPECIALIDAD` varchar(100) NOT NULL,
  `DESCRIPCION` text,
  `COLOR_HEXADECIMAL` varchar(7) DEFAULT '#3498DB',
  `ICONO` varchar(50) DEFAULT NULL,
  `ESTADO` enum('ACTIVA','INACTIVA') DEFAULT 'ACTIVA',
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_ESPECIALIDAD`),
  UNIQUE KEY `NOMBRE_ESPECIALIDAD` (`NOMBRE_ESPECIALIDAD`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_especialidades`
--

LOCK TABLES `tbl_especialidades` WRITE;
/*!40000 ALTER TABLE `tbl_especialidades` DISABLE KEYS */;
INSERT INTO `tbl_especialidades` VALUES (1,'MEDICINA GENERAL','ATENCIÓN PRIMARIA Y GENERAL','#3498DB',NULL,'ACTIVA','2025-11-26 23:37:20','SISTEMA',NULL),(2,'PEDIATRÍA','ESPECIALIDAD EN NIÑOS','#3498DB',NULL,'ACTIVA','2025-11-26 23:37:20','SISTEMA',NULL),(3,'GINECOLOGÍA','SALUD FEMENINA','#3498DB',NULL,'ACTIVA','2025-11-26 23:37:20','SISTEMA',NULL),(4,'CARDIOLOGÍA','ESPECIALIDAD DEL CORAZÓN','#3498db','fas fa-heartbeat','ACTIVA','2025-11-26 23:37:20','SISTEMA','SISTEMA'),(5,'DERMATOLOGÍA','ESPECIALIDAD DE LA PIEL','#3498DB',NULL,'ACTIVA','2025-11-26 23:37:20','SISTEMA',NULL);
/*!40000 ALTER TABLE `tbl_especialidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_factura`
--

DROP TABLE IF EXISTS `tbl_factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_factura` (
  `ID_FACTURA` int NOT NULL AUTO_INCREMENT,
  `ID_CITA` int DEFAULT NULL,
  `ID_PACIENTE` int NOT NULL,
  `FECHA_EMISION` datetime DEFAULT CURRENT_TIMESTAMP,
  `RTN_PACIENTE` varchar(50) DEFAULT NULL,
  `CAI` varchar(100) DEFAULT NULL,
  `NUMERO_FACTURA` varchar(50) NOT NULL,
  `ESTADO_FACTURA` enum('PENDIENTE','PAGADA','ANULADA','PARCIAL') DEFAULT 'PENDIENTE',
  `SUBTOTAL` decimal(10,2) DEFAULT '0.00',
  `ISV` decimal(10,2) DEFAULT '0.00',
  `DESCUENTO` decimal(10,2) DEFAULT '0.00',
  `MONTO_TOTAL` decimal(10,2) DEFAULT '0.00',
  `SALDO_PENDIENTE` decimal(10,2) DEFAULT '0.00',
  `FECHA_VENCIMIENTO` date DEFAULT NULL,
  `TERMINOS_PAGO` varchar(100) DEFAULT 'CONTADO',
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_FACTURA`),
  UNIQUE KEY `NUMERO_FACTURA` (`NUMERO_FACTURA`),
  KEY `ID_CITA` (`ID_CITA`),
  KEY `idx_factura_paciente` (`ID_PACIENTE`),
  KEY `idx_factura_estado` (`ESTADO_FACTURA`),
  KEY `idx_factura_fecha` (`FECHA_EMISION`),
  CONSTRAINT `tbl_factura_ibfk_1` FOREIGN KEY (`ID_PACIENTE`) REFERENCES `tbl_paciente` (`ID_PACIENTE`),
  CONSTRAINT `tbl_factura_ibfk_2` FOREIGN KEY (`ID_CITA`) REFERENCES `tbl_citas` (`ID_CITA`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_factura`
--

LOCK TABLES `tbl_factura` WRITE;
/*!40000 ALTER TABLE `tbl_factura` DISABLE KEYS */;
INSERT INTO `tbl_factura` VALUES (1,1,1,'2025-11-26 23:37:20',NULL,NULL,'FACT-20251126-0001','PENDIENTE',800.00,120.00,0.00,920.00,920.00,'2025-12-11','CONTADO','RECEP.ANA','RECEP.ANA');
/*!40000 ALTER TABLE `tbl_factura` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_FACTURAS_INSERT` AFTER INSERT ON `tbl_factura` FOR EACH ROW BEGIN
    DECLARE v_id_usuario_creador INT;
    
    -- Buscar ID del usuario creador
    SELECT COALESCE(ID_USUARIO, 1) INTO v_id_usuario_creador 
    FROM TBL_MS_USUARIO 
    WHERE USUARIO = COALESCE(NEW.USUARIO_CREACION, 'SISTEMA')
    LIMIT 1;
    
    CALL SP_REGISTRAR_BITACORA(
        v_id_usuario_creador,
        'CREACION_FACTURA',
        CONCAT('Factura creada: ', NEW.NUMERO_FACTURA, ' - Monto: L', NEW.MONTO_TOTAL),
        'FACTURACION',
        NEW.ID_FACTURA,
        'TBL_FACTURA',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_FACTURAS_UPDATE` AFTER UPDATE ON `tbl_factura` FOR EACH ROW BEGIN
    DECLARE v_id_usuario_modificador INT;
    
    IF OLD.ESTADO_FACTURA != NEW.ESTADO_FACTURA THEN
        -- Buscar ID del usuario modificador
        SELECT COALESCE(ID_USUARIO, 1) INTO v_id_usuario_modificador 
        FROM TBL_MS_USUARIO 
        WHERE USUARIO = COALESCE(NEW.USUARIO_MODIFICACION, 'SISTEMA')
        LIMIT 1;
        
        CALL SP_REGISTRAR_BITACORA(
            v_id_usuario_modificador,
            'CAMBIO_ESTADO_FACTURA',
            CONCAT('Factura ', NEW.NUMERO_FACTURA, ' cambió de ', OLD.ESTADO_FACTURA, ' a ', NEW.ESTADO_FACTURA),
            'FACTURACION',
            NEW.ID_FACTURA,
            'TBL_FACTURA',
            NULL, NULL, 'EXITO', NULL,
            'TRIGGER'
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_historial_medico`
--

DROP TABLE IF EXISTS `tbl_historial_medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_historial_medico` (
  `ID_HISTORIAL` int NOT NULL AUTO_INCREMENT,
  `ID_PACIENTE` int NOT NULL,
  `ALERGIAS` json DEFAULT NULL,
  `ENFERMEDADES_CRONICAS` json DEFAULT NULL,
  `CIRUGIAS_PREVIAS` json DEFAULT NULL,
  `MEDICAMENTOS_ACTUALES` json DEFAULT NULL,
  `ANTECEDENTES_FAMILIARES` json DEFAULT NULL,
  `HABITOS` json DEFAULT NULL COMMENT 'TABACO, ALCOHOL, EJERCICIO, ETC.',
  `VACUNAS` json DEFAULT NULL,
  `NOTAS_IMPORTANTES` text,
  `FECHA_ACTUALIZACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ID_USUARIO_ACTUALIZO` int DEFAULT NULL,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_HISTORIAL`),
  UNIQUE KEY `ID_PACIENTE` (`ID_PACIENTE`),
  KEY `ID_USUARIO_ACTUALIZO` (`ID_USUARIO_ACTUALIZO`),
  CONSTRAINT `tbl_historial_medico_ibfk_1` FOREIGN KEY (`ID_PACIENTE`) REFERENCES `tbl_paciente` (`ID_PACIENTE`) ON DELETE CASCADE,
  CONSTRAINT `tbl_historial_medico_ibfk_2` FOREIGN KEY (`ID_USUARIO_ACTUALIZO`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_historial_medico`
--

LOCK TABLES `tbl_historial_medico` WRITE;
/*!40000 ALTER TABLE `tbl_historial_medico` DISABLE KEYS */;
INSERT INTO `tbl_historial_medico` VALUES (1,1,'[\"PENICILINA\", \"MARISCOS\"]','[\"HIPERTENSIÓN ARTERIAL\"]','[\"APENDICECTOMÍA (2010)\"]','[\"LOSARTAN 100MG\", \"HIDROCLOROTIAZIDA 12.5MG\", \"ASPIRINA 100MG\"]','{\"MADRE\": \"HIPERTENSIÓN\", \"PADRE\": \"DIABETES\"}','{\"TABACO\": \"NO\", \"ALCOHOL\": \"OCASIONAL\", \"EJERCICIO\": \"3_VECES_POR_SEMANA\"}','[\"INFLUENZA_2023\", \"TÉTANOS_2018\"]','PACIENTE CON HIPERTENSIÓN CONTROLADA. REVISIONES CADA 6 MESES.','2025-11-26 23:37:20',2,'ADMIN','DR.GARCIA'),(2,2,'[]','[\"DIABETES TIPO 2\"]','[\"COLECISTECTOMÍA (2015)\"]','[\"METFORMINA 850MG\", \"GLIBENCLAMIDA 5MG\"]','{\"PADRE\": \"DIABETES\", \"HERMANO\": \"HIPERTENSIÓN\"}','{\"TABACO\": \"NO\", \"ALCOHOL\": \"MODERADO\", \"EJERCICIO\": \"CAMINATAS_DIARIAS\"}','[\"INFLUENZA_2023\", \"COVID-19_COMPLETA\"]','DIABÉTICO CONTROLADO. USO DE GLUCÓMETRO DIARIO.','2025-11-26 23:37:20',1,'ADMIN',NULL);
/*!40000 ALTER TABLE `tbl_historial_medico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_inventario_medicamentos`
--

DROP TABLE IF EXISTS `tbl_inventario_medicamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_inventario_medicamentos` (
  `ID_MEDICAMENTO` int NOT NULL AUTO_INCREMENT,
  `NOMBRE_MEDICAMENTO` varchar(255) NOT NULL,
  `NOMBRE_GENERICO` varchar(255) DEFAULT NULL,
  `DESCRIPCION` text,
  `PRESENTACION` varchar(100) DEFAULT NULL,
  `CONCENTRACION` varchar(50) DEFAULT NULL,
  `VIA_ADMINISTRACION` varchar(50) DEFAULT NULL,
  `STOCK_ACTUAL` int DEFAULT '0',
  `STOCK_MINIMO` int DEFAULT '10',
  `STOCK_MAXIMO` int DEFAULT '100',
  `PRECIO_COMPRA` decimal(10,2) DEFAULT NULL,
  `PRECIO_VENTA` decimal(10,2) DEFAULT NULL,
  `LOTE` varchar(100) DEFAULT NULL,
  `FECHA_VENCIMIENTO` date DEFAULT NULL,
  `PROVEEDOR` varchar(255) DEFAULT NULL,
  `REQUIERE_RECETA` tinyint(1) DEFAULT '1',
  `ESTADO` enum('ACTIVO','INACTIVO','VENCIDO') DEFAULT 'ACTIVO',
  `FECHA_REGISTRO` datetime DEFAULT CURRENT_TIMESTAMP,
  `ID_USUARIO_REGISTRO` int DEFAULT NULL,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_MEDICAMENTO`),
  KEY `ID_USUARIO_REGISTRO` (`ID_USUARIO_REGISTRO`),
  KEY `idx_medicamento_nombre` (`NOMBRE_MEDICAMENTO`),
  KEY `idx_medicamento_vencimiento` (`FECHA_VENCIMIENTO`),
  KEY `idx_medicamento_stock` (`STOCK_ACTUAL`),
  CONSTRAINT `tbl_inventario_medicamentos_ibfk_1` FOREIGN KEY (`ID_USUARIO_REGISTRO`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_inventario_medicamentos`
--

LOCK TABLES `tbl_inventario_medicamentos` WRITE;
/*!40000 ALTER TABLE `tbl_inventario_medicamentos` DISABLE KEYS */;
INSERT INTO `tbl_inventario_medicamentos` VALUES (1,'LOSARTAN','LOSARTAN POTÁSICO','ANTAGONISTA DE RECEPTORES DE ANGIOTENSINA II','TABLETAS','100MG','ORAL',102,20,200,3.50,5.50,'LOT-202401-001','2025-12-31','LABORATORIOS FARMACÉUTICOS S.A.',1,'ACTIVO','2025-11-26 23:37:20',1,'ADMIN','ADMIN'),(2,'HIDROCLOROTIAZIDA','HIDROCLOROTIAZIDA','DIURÉTICO TIAZÍDICO','TABLETAS','12.5MG','ORAL',150,30,300,1.80,3.20,'LOT-202401-002','2025-10-31','LABORATORIOS MÉDICOS HONDUREÑOS',1,'ACTIVO','2025-11-26 23:37:20',1,'ADMIN','ADMIN'),(3,'Antibióticos','Antibióticos',NULL,'tabletas',NULL,NULL,40,10,100,0.00,23.00,NULL,'2025-10-27',NULL,1,'ACTIVO','2025-11-27 12:28:45',1,'ADMIN_SISTEMA','ADMIN_TEMPORAL');
/*!40000 ALTER TABLE `tbl_inventario_medicamentos` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_MEDICAMENTOS_INSERT` AFTER INSERT ON `tbl_inventario_medicamentos` FOR EACH ROW BEGIN
    CALL SP_REGISTRAR_BITACORA(
        COALESCE(NEW.ID_USUARIO_REGISTRO, 1),
        'CREACION_MEDICAMENTO',
        CONCAT('Medicamento agregado: ', NEW.NOMBRE_MEDICAMENTO, ' - Stock: ', NEW.STOCK_ACTUAL),
        'FARMACIA',
        NEW.ID_MEDICAMENTO,
        'TBL_INVENTARIO_MEDICAMENTO',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_MEDICAMENTOS_UPDATE` AFTER UPDATE ON `tbl_inventario_medicamentos` FOR EACH ROW BEGIN
    DECLARE v_cambios TEXT DEFAULT '';
    DECLARE v_id_usuario_modificador INT;
    
    IF OLD.STOCK_ACTUAL != NEW.STOCK_ACTUAL THEN
        SET v_cambios = CONCAT(v_cambios, 'Stock: ', OLD.STOCK_ACTUAL, ' → ', NEW.STOCK_ACTUAL, '; ');
    END IF;
    
    IF OLD.PRECIO_VENTA != NEW.PRECIO_VENTA THEN
        SET v_cambios = CONCAT(v_cambios, 'Precio: ', OLD.PRECIO_VENTA, ' → ', NEW.PRECIO_VENTA, '; ');
    END IF;
    
    IF OLD.ESTADO != NEW.ESTADO THEN
        SET v_cambios = CONCAT(v_cambios, 'Estado: ', OLD.ESTADO, ' → ', NEW.ESTADO, '; ');
    END IF;
    
    IF v_cambios != '' THEN
        -- Buscar ID del usuario modificador
        SELECT COALESCE(ID_USUARIO, 1) INTO v_id_usuario_modificador 
        FROM TBL_MS_USUARIO 
        WHERE USUARIO = COALESCE(NEW.USUARIO_MODIFICACION, 'SISTEMA')
        LIMIT 1;
        
        CALL SP_REGISTRAR_BITACORA(
            v_id_usuario_modificador,
            'ACTUALIZACION_MEDICAMENTO',
            CONCAT('Medicamento actualizado: ', NEW.NOMBRE_MEDICAMENTO, ' - Cambios: ', v_cambios),
            'FARMACIA',
            NEW.ID_MEDICAMENTO,
            'TBL_INVENTARIO_MEDICAMENTO',
            NULL, NULL, 'EXITO', NULL,
            'TRIGGER'
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_ms_bitacora`
--

DROP TABLE IF EXISTS `tbl_ms_bitacora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_ms_bitacora` (
  `ID_BITACORA` int NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` int DEFAULT NULL,
  `FECHA_HORA` datetime DEFAULT CURRENT_TIMESTAMP,
  `ACCION` varchar(100) NOT NULL,
  `DESCRIPCION` text,
  `MODULO` varchar(50) DEFAULT NULL,
  `ID_REGISTRO_AFECTADO` int DEFAULT NULL,
  `TABLA_AFECTADA` varchar(50) DEFAULT NULL,
  `IP_CLIENTE` varchar(45) DEFAULT NULL,
  `USER_AGENT` varchar(500) DEFAULT NULL,
  `ESTADO_OPERACION` enum('EXITO','ERROR','ADVERTENCIA') DEFAULT 'EXITO',
  `DETALLE_ERROR` text,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_BITACORA`),
  KEY `idx_bitacora_usuario` (`ID_USUARIO`),
  KEY `idx_bitacora_fecha` (`FECHA_HORA`),
  KEY `idx_bitacora_modulo` (`MODULO`),
  KEY `idx_bitacora_accion` (`ACCION`),
  CONSTRAINT `tbl_ms_bitacora_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=563 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_ms_bitacora`
--

LOCK TABLES `tbl_ms_bitacora` WRITE;
/*!40000 ALTER TABLE `tbl_ms_bitacora` DISABLE KEYS */;
INSERT INTO `tbl_ms_bitacora` VALUES (1,NULL,'2025-11-26 23:37:20','CREACION_ROL','Nuevo rol creado: ADMINISTRADOR','ROLES',1,'TBL_MS_ROLES',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(2,NULL,'2025-11-26 23:37:20','CREACION_ROL','Nuevo rol creado: DOCTOR','ROLES',2,'TBL_MS_ROLES',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(3,NULL,'2025-11-26 23:37:20','CREACION_ROL','Nuevo rol creado: ENFERMERA','ROLES',3,'TBL_MS_ROLES',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(4,NULL,'2025-11-26 23:37:20','CREACION_ROL','Nuevo rol creado: RECEPCIONISTA','ROLES',4,'TBL_MS_ROLES',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(5,NULL,'2025-11-26 23:37:20','CREACION_ROL','Nuevo rol creado: PACIENTE','ROLES',5,'TBL_MS_ROLES',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(6,NULL,'2025-11-26 23:37:20','CREACION_USUARIO','Nuevo usuario creado: ADMIN - ADMINISTRADOR DEL SISTEMA','USUARIOS',1,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(7,1,'2025-11-26 23:37:20','CREACION_PACIENTE','Nuevo paciente creado: MARÍA ELENA GARCÍA MARTÍNEZ (0801-1985-12345)','PACIENTES',1,'TBL_PACIENTE',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(8,1,'2025-11-26 23:37:20','CREACION_PACIENTE','Nuevo paciente creado: JUAN CARLOS LÓPEZ HERNÁNDEZ (0801-1978-98765)','PACIENTES',2,'TBL_PACIENTE',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(9,1,'2025-11-26 23:37:20','CREACION_USUARIO','Nuevo usuario creado: DR.GARCIA - DR. ROBERTO GARCÍA LÓPEZ','USUARIOS',2,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(10,1,'2025-11-26 23:37:20','CREACION_USUARIO','Nuevo usuario creado: ENF.ROSA - LIC. ROSA MARÍA HERNÁNDEZ','USUARIOS',3,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(11,1,'2025-11-26 23:37:20','CREACION_USUARIO','Nuevo usuario creado: RECEP.ANA - ANA LUCÍA GÓMEZ','USUARIOS',4,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(12,4,'2025-11-26 23:37:20','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',1,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(13,3,'2025-11-26 23:37:20','CAMBIO_ESTADO_CITA','Cita ID 1 cambió de PROGRAMADA a PRECLINICA','CITAS',1,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(14,2,'2025-11-26 23:37:20','CAMBIO_ESTADO_CITA','Cita ID 1 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',1,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(15,2,'2025-11-26 23:37:20','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: HIPERTENSIÓN ARTERIAL ESENCIAL NO CONTROLADA','CONSULTAS',1,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(16,1,'2025-11-26 23:37:20','CREACION_MEDICAMENTO','Medicamento agregado: LOSARTAN - Stock: 100','FARMACIA',1,'TBL_INVENTARIO_MEDICAMENTO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(17,1,'2025-11-26 23:37:20','CREACION_MEDICAMENTO','Medicamento agregado: HIDROCLOROTIAZIDA - Stock: 150','FARMACIA',2,'TBL_INVENTARIO_MEDICAMENTO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(18,2,'2025-11-26 23:37:20','PRESCRIPCION_MEDICA','Prescripción de LOSARTAN - Dosis: 100MG','FARMACIA',1,'TBL_PRESCRIPCION',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(19,2,'2025-11-26 23:37:20','PRESCRIPCION_MEDICA','Prescripción de HIDROCLOROTIAZIDA - Dosis: 12.5MG','FARMACIA',2,'TBL_PRESCRIPCION',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(20,4,'2025-11-26 23:37:20','CREACION_FACTURA','Factura creada: FACT-20251126-0001 - Monto: L920.00','FACTURACION',1,'TBL_FACTURA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(21,2,'2025-11-26 23:37:20','CAMBIO_ESTADO_CITA','Cita ID 1 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',1,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:37:20'),(22,1,'2025-11-26 23:37:20','LOGIN_EXITOSO','Usuario ADMIN inició sesión correctamente','AUTENTICACION',NULL,'TBL_MS_USUARIO','192.168.1.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36','EXITO',NULL,'SISTEMA','2025-11-26 23:37:20'),(23,4,'2025-11-26 23:37:20','CREACION_CITA_MANUAL','Recepcionista creó cita manual para paciente María Elena García','CITAS',1,'TBL_CITAS','192.168.1.101','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36','EXITO',NULL,'RECEP.ANA','2025-11-26 23:37:20'),(24,1,'2025-11-26 23:37:20','ACTIVACION_2FA','Administrador activó autenticación de dos factores','SEGURIDAD',1,'TBL_MS_USUARIO','192.168.1.100','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36','EXITO',NULL,'SISTEMA','2025-11-26 23:37:20'),(25,NULL,'2025-11-26 23:39:16','CREACION_USUARIO','Nuevo usuario creado: usuario - Eduar Dominguez','USUARIOS',5,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-26 23:39:16'),(26,5,'2025-11-26 23:39:16','REGISTRO','Nuevo usuario registrado: usuario','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-26 23:39:16'),(27,5,'2025-11-26 23:39:21','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-26 23:39:21'),(28,5,'2025-11-26 23:43:53','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-26 23:43:53'),(29,5,'2025-11-26 23:44:58','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-26 23:44:58'),(30,5,'2025-11-27 00:51:12','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:51:12'),(31,1,'2025-11-27 00:51:21','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:51:21'),(32,1,'2025-11-27 00:51:27','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:51:27'),(33,1,'2025-11-27 00:51:38','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',2,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:51:38'),(34,1,'2025-11-27 00:51:38','CREACION_CITA','Creada cita ID 2 paciente 2 doctor 2','CITAS',2,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:51:38'),(35,1,'2025-11-27 00:51:40','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 2','CITAS',2,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:51:40'),(36,1,'2025-11-27 00:51:41','CAMBIO_ESTADO_CITA','Cita ID 2 cambió de PROGRAMADA a CONFIRMADA','CITAS',2,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:51:41'),(37,1,'2025-11-27 00:51:41','CAMBIO_ESTADO_CITA','Cita 2 -> CONFIRMADA','CITAS',2,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:51:41'),(38,1,'2025-11-27 00:51:43','CAMBIO_ESTADO_CITA','Cita ID 2 cambió de CONFIRMADA a PRECLINICA','CITAS',2,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:51:43'),(39,1,'2025-11-27 00:51:43','CAMBIO_ESTADO_CITA','Cita 2 -> PRECLINICA','CITAS',2,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:51:43'),(40,1,'2025-11-27 00:51:47','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:51:47'),(41,1,'2025-11-27 00:52:15','CREACION_PRECLINICA','Creada preclínica ID 2 para cita 2','PRECLINICA',2,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:52:15'),(42,1,'2025-11-27 00:52:15','CAMBIO_ESTADO_CITA','Cita ID 2 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',2,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:52:15'),(43,1,'2025-11-27 00:52:15','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 2 -> CONSULTA_MEDICA tras crear preclínica 2','CITAS',2,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:52:15'),(44,1,'2025-11-27 00:52:19','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:52:19'),(45,2,'2025-11-27 00:52:35','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: j','CONSULTAS',2,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:52:35'),(46,1,'2025-11-27 00:52:35','CREACION_CONSULTA_MEDICA','Creada consulta ID 2 para cita 2','CONSULTA_MEDICA',2,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:52:35'),(47,1,'2025-11-27 00:52:35','CAMBIO_ESTADO_CITA','Cita ID 2 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',2,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:52:35'),(48,5,'2025-11-27 00:53:53','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:53:53'),(49,1,'2025-11-27 00:53:56','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:53:56'),(50,1,'2025-11-27 00:54:00','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:00'),(51,1,'2025-11-27 00:54:12','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',3,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:54:12'),(52,1,'2025-11-27 00:54:12','CREACION_CITA','Creada cita ID 3 paciente 2 doctor 2','CITAS',3,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:12'),(53,1,'2025-11-27 00:54:14','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 3','CITAS',3,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:14'),(54,1,'2025-11-27 00:54:14','CAMBIO_ESTADO_CITA','Cita ID 3 cambió de PROGRAMADA a CONFIRMADA','CITAS',3,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:54:14'),(55,1,'2025-11-27 00:54:14','CAMBIO_ESTADO_CITA','Cita 3 -> CONFIRMADA','CITAS',3,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:14'),(56,1,'2025-11-27 00:54:19','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:19'),(57,1,'2025-11-27 00:54:22','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:22'),(58,1,'2025-11-27 00:54:24','CAMBIO_ESTADO_CITA','Cita ID 3 cambió de CONFIRMADA a PRECLINICA','CITAS',3,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:54:24'),(59,1,'2025-11-27 00:54:24','CAMBIO_ESTADO_CITA','Cita 3 -> PRECLINICA','CITAS',3,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:24'),(60,1,'2025-11-27 00:54:26','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:26'),(61,1,'2025-11-27 00:54:55','CREACION_PRECLINICA','Creada preclínica ID 3 para cita 3','PRECLINICA',3,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:55'),(62,1,'2025-11-27 00:54:55','CAMBIO_ESTADO_CITA','Cita ID 3 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',3,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:54:55'),(63,1,'2025-11-27 00:54:55','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 3 -> CONSULTA_MEDICA tras crear preclínica 3','CITAS',3,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:55'),(64,1,'2025-11-27 00:54:59','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:54:59'),(65,2,'2025-11-27 00:55:16','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: ooo','CONSULTAS',3,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:55:16'),(66,1,'2025-11-27 00:55:16','CREACION_CONSULTA_MEDICA','Creada consulta ID 3 para cita 3','CONSULTA_MEDICA',3,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 00:55:16'),(67,1,'2025-11-27 00:55:16','CAMBIO_ESTADO_CITA','Cita ID 3 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',3,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 00:55:16'),(68,5,'2025-11-27 01:10:05','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:05'),(69,1,'2025-11-27 01:10:07','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:07'),(70,1,'2025-11-27 01:10:20','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',4,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:10:20'),(71,1,'2025-11-27 01:10:20','CREACION_CITA','Creada cita ID 4 paciente 1 doctor 2','CITAS',4,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:20'),(72,1,'2025-11-27 01:10:21','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 4','CITAS',4,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:21'),(73,1,'2025-11-27 01:10:22','CAMBIO_ESTADO_CITA','Cita ID 4 cambió de PROGRAMADA a CONFIRMADA','CITAS',4,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:10:22'),(74,1,'2025-11-27 01:10:22','CAMBIO_ESTADO_CITA','Cita 4 -> CONFIRMADA','CITAS',4,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:22'),(75,1,'2025-11-27 01:10:27','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:27'),(76,1,'2025-11-27 01:10:30','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:30'),(77,1,'2025-11-27 01:10:32','CAMBIO_ESTADO_CITA','Cita ID 4 cambió de CONFIRMADA a PRECLINICA','CITAS',4,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:10:32'),(78,1,'2025-11-27 01:10:32','CAMBIO_ESTADO_CITA','Cita 4 -> PRECLINICA','CITAS',4,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:32'),(79,1,'2025-11-27 01:10:36','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:36'),(80,1,'2025-11-27 01:10:46','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:10:46'),(81,1,'2025-11-27 01:11:12','CREACION_PRECLINICA','Creada preclínica ID 4 para cita 4','PRECLINICA',4,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:11:12'),(82,1,'2025-11-27 01:11:12','CAMBIO_ESTADO_CITA','Cita ID 4 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',4,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:11:12'),(83,1,'2025-11-27 01:11:12','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 4 -> CONSULTA_MEDICA tras crear preclínica 4','CITAS',4,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:11:12'),(84,1,'2025-11-27 01:11:15','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:11:15'),(85,2,'2025-11-27 01:11:32','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: h','CONSULTAS',4,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:11:32'),(86,1,'2025-11-27 01:11:32','CREACION_CONSULTA_MEDICA','Creada consulta ID 4 para cita 4','CONSULTA_MEDICA',4,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:11:32'),(87,1,'2025-11-27 01:11:32','CAMBIO_ESTADO_CITA','Cita ID 4 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',4,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:11:32'),(88,5,'2025-11-27 01:15:21','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:15:21'),(89,5,'2025-11-27 01:18:04','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:18:04'),(90,1,'2025-11-27 01:18:30','ACCESO_ESPECIALIDADES','Acceso a la vista de especialidades','ESPECIALIDADES',NULL,'TBL_ESPECIALIDADES','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:18:30'),(91,1,'2025-11-27 01:18:40','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:18:40'),(92,1,'2025-11-27 01:18:55','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',5,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:18:55'),(93,1,'2025-11-27 01:18:55','CREACION_CITA','Creada cita ID 5 paciente 2 doctor 2','CITAS',5,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:18:55'),(94,1,'2025-11-27 01:18:57','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 5','CITAS',5,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:18:57'),(95,1,'2025-11-27 01:18:57','CAMBIO_ESTADO_CITA','Cita ID 5 cambió de PROGRAMADA a CONFIRMADA','CITAS',5,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:18:57'),(96,1,'2025-11-27 01:18:57','CAMBIO_ESTADO_CITA','Cita 5 -> CONFIRMADA','CITAS',5,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:18:57'),(97,1,'2025-11-27 01:18:59','CAMBIO_ESTADO_CITA','Cita ID 5 cambió de CONFIRMADA a PRECLINICA','CITAS',5,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:18:59'),(98,1,'2025-11-27 01:18:59','CAMBIO_ESTADO_CITA','Cita 5 -> PRECLINICA','CITAS',5,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:18:59'),(99,1,'2025-11-27 01:19:02','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:19:02'),(100,1,'2025-11-27 01:19:42','CREACION_PRECLINICA','Creada preclínica ID 5 para cita 5','PRECLINICA',5,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:19:42'),(101,1,'2025-11-27 01:19:42','CAMBIO_ESTADO_CITA','Cita ID 5 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',5,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:19:42'),(102,1,'2025-11-27 01:19:42','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 5 -> CONSULTA_MEDICA tras crear preclínica 5','CITAS',5,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:19:42'),(103,1,'2025-11-27 01:19:47','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:19:47'),(104,2,'2025-11-27 01:20:04','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: i','CONSULTAS',5,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:20:04'),(105,1,'2025-11-27 01:20:04','CREACION_CONSULTA_MEDICA','Creada consulta ID 5 para cita 5','CONSULTA_MEDICA',5,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:20:04'),(106,1,'2025-11-27 01:20:04','CAMBIO_ESTADO_CITA','Cita ID 5 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',5,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:20:04'),(107,1,'2025-11-27 01:21:34','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:21:34'),(108,1,'2025-11-27 01:21:47','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',6,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:21:47'),(109,1,'2025-11-27 01:21:47','CREACION_CITA','Creada cita ID 6 paciente 2 doctor 2','CITAS',6,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:21:47'),(110,1,'2025-11-27 01:21:48','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 6','CITAS',6,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:21:48'),(111,1,'2025-11-27 01:21:49','CAMBIO_ESTADO_CITA','Cita ID 6 cambió de PROGRAMADA a CONFIRMADA','CITAS',6,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:21:49'),(112,1,'2025-11-27 01:21:49','CAMBIO_ESTADO_CITA','Cita 6 -> CONFIRMADA','CITAS',6,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:21:49'),(113,1,'2025-11-27 01:21:51','CAMBIO_ESTADO_CITA','Cita ID 6 cambió de CONFIRMADA a PRECLINICA','CITAS',6,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:21:51'),(114,1,'2025-11-27 01:21:51','CAMBIO_ESTADO_CITA','Cita 6 -> PRECLINICA','CITAS',6,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:21:51'),(115,5,'2025-11-27 01:22:13','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:22:13'),(116,1,'2025-11-27 01:22:16','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:22:16'),(117,1,'2025-11-27 01:22:51','CREACION_PRECLINICA','Creada preclínica ID 6 para cita 6','PRECLINICA',6,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:22:51'),(118,1,'2025-11-27 01:22:51','CAMBIO_ESTADO_CITA','Cita ID 6 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',6,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:22:51'),(119,1,'2025-11-27 01:22:51','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 6 -> CONSULTA_MEDICA tras crear preclínica 6','CITAS',6,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:22:51'),(120,1,'2025-11-27 01:22:55','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:22:55'),(121,2,'2025-11-27 01:23:14','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: o','CONSULTAS',6,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:23:14'),(122,1,'2025-11-27 01:23:14','CREACION_CONSULTA_MEDICA','Creada consulta ID 6 para cita 6','CONSULTA_MEDICA',6,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:23:14'),(123,1,'2025-11-27 01:23:14','CAMBIO_ESTADO_CITA','Cita ID 6 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',6,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:23:14'),(124,5,'2025-11-27 01:24:25','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:24:25'),(125,1,'2025-11-27 01:24:28','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:24:28'),(126,1,'2025-11-27 01:24:38','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',7,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:24:38'),(127,1,'2025-11-27 01:24:38','CREACION_CITA','Creada cita ID 7 paciente 2 doctor 2','CITAS',7,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:24:38'),(128,1,'2025-11-27 01:24:39','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 7','CITAS',7,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:24:39'),(129,1,'2025-11-27 01:24:40','CAMBIO_ESTADO_CITA','Cita ID 7 cambió de PROGRAMADA a CONFIRMADA','CITAS',7,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:24:40'),(130,1,'2025-11-27 01:24:40','CAMBIO_ESTADO_CITA','Cita 7 -> CONFIRMADA','CITAS',7,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:24:40'),(131,1,'2025-11-27 01:24:42','CAMBIO_ESTADO_CITA','Cita ID 7 cambió de CONFIRMADA a PRECLINICA','CITAS',7,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:24:42'),(132,1,'2025-11-27 01:24:42','CAMBIO_ESTADO_CITA','Cita 7 -> PRECLINICA','CITAS',7,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:24:42'),(133,1,'2025-11-27 01:24:48','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:24:48'),(134,1,'2025-11-27 01:25:27','CREACION_PRECLINICA','Creada preclínica ID 7 para cita 7','PRECLINICA',7,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:25:27'),(135,1,'2025-11-27 01:25:27','CAMBIO_ESTADO_CITA','Cita ID 7 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',7,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:25:27'),(136,1,'2025-11-27 01:25:27','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 7 -> CONSULTA_MEDICA tras crear preclínica 7','CITAS',7,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:25:27'),(137,1,'2025-11-27 01:25:32','ACCESO_ESPECIALIDADES','Acceso a la vista de especialidades','ESPECIALIDADES',NULL,'TBL_ESPECIALIDADES','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:25:32'),(138,1,'2025-11-27 01:25:36','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:25:36'),(139,2,'2025-11-27 01:25:51','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: i','CONSULTAS',7,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:25:51'),(140,1,'2025-11-27 01:25:51','CREACION_CONSULTA_MEDICA','Creada consulta ID 7 para cita 7','CONSULTA_MEDICA',7,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:25:51'),(141,1,'2025-11-27 01:25:51','CAMBIO_ESTADO_CITA','Cita ID 7 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',7,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:25:51'),(142,5,'2025-11-27 01:28:11','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:28:11'),(143,1,'2025-11-27 01:28:23','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:28:23'),(144,1,'2025-11-27 01:28:32','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',8,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:28:32'),(145,1,'2025-11-27 01:28:32','CREACION_CITA','Creada cita ID 8 paciente 2 doctor 2','CITAS',8,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:28:32'),(146,1,'2025-11-27 01:28:33','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 8','CITAS',8,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:28:33'),(147,1,'2025-11-27 01:28:35','CAMBIO_ESTADO_CITA','Cita ID 8 cambió de PROGRAMADA a CONFIRMADA','CITAS',8,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:28:35'),(148,1,'2025-11-27 01:28:35','CAMBIO_ESTADO_CITA','Cita 8 -> CONFIRMADA','CITAS',8,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:28:35'),(149,1,'2025-11-27 01:28:36','CAMBIO_ESTADO_CITA','Cita ID 8 cambió de CONFIRMADA a PRECLINICA','CITAS',8,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:28:36'),(150,1,'2025-11-27 01:28:36','CAMBIO_ESTADO_CITA','Cita 8 -> PRECLINICA','CITAS',8,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:28:36'),(151,1,'2025-11-27 01:28:39','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:28:39'),(152,1,'2025-11-27 01:29:09','CREACION_PRECLINICA','Creada preclínica ID 8 para cita 8','PRECLINICA',8,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:29:09'),(153,1,'2025-11-27 01:29:09','CAMBIO_ESTADO_CITA','Cita ID 8 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',8,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:29:09'),(154,1,'2025-11-27 01:29:09','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 8 -> CONSULTA_MEDICA tras crear preclínica 8','CITAS',8,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:29:09'),(155,1,'2025-11-27 01:29:15','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:29:15'),(156,2,'2025-11-27 01:29:30','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: k','CONSULTAS',8,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:29:30'),(157,1,'2025-11-27 01:29:30','CREACION_CONSULTA_MEDICA','Creada consulta ID 8 para cita 8','CONSULTA_MEDICA',8,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:29:30'),(158,1,'2025-11-27 01:29:30','CAMBIO_ESTADO_CITA','Cita ID 8 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',8,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:29:30'),(159,5,'2025-11-27 01:35:56','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:35:56'),(160,5,'2025-11-27 01:43:24','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:43:24'),(161,1,'2025-11-27 01:43:39','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:43:39'),(162,1,'2025-11-27 01:44:10','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',9,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:44:10'),(163,1,'2025-11-27 01:44:10','CREACION_CITA','Creada cita ID 9 paciente 1 doctor 2','CITAS',9,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:44:10'),(164,1,'2025-11-27 01:44:11','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 9','CITAS',9,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:44:11'),(165,1,'2025-11-27 01:44:14','CAMBIO_ESTADO_CITA','Cita ID 9 cambió de PROGRAMADA a CONFIRMADA','CITAS',9,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:44:14'),(166,1,'2025-11-27 01:44:14','CAMBIO_ESTADO_CITA','Cita 9 -> CONFIRMADA','CITAS',9,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:44:14'),(167,1,'2025-11-27 01:44:16','CAMBIO_ESTADO_CITA','Cita ID 9 cambió de CONFIRMADA a PRECLINICA','CITAS',9,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:44:16'),(168,1,'2025-11-27 01:44:16','CAMBIO_ESTADO_CITA','Cita 9 -> PRECLINICA','CITAS',9,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:44:16'),(169,1,'2025-11-27 01:44:22','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:44:22'),(170,1,'2025-11-27 01:44:53','CREACION_PRECLINICA','Creada preclínica ID 9 para cita 9','PRECLINICA',9,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:44:53'),(171,1,'2025-11-27 01:44:53','CAMBIO_ESTADO_CITA','Cita ID 9 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',9,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:44:53'),(172,1,'2025-11-27 01:44:53','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 9 -> CONSULTA_MEDICA tras crear preclínica 9','CITAS',9,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:44:53'),(173,1,'2025-11-27 01:44:56','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:44:56'),(174,2,'2025-11-27 01:46:00','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: i','CONSULTAS',9,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:46:00'),(175,1,'2025-11-27 01:46:00','CREACION_CONSULTA_MEDICA','Creada consulta ID 9 para cita 9','CONSULTA_MEDICA',9,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:46:00'),(176,1,'2025-11-27 01:46:00','CAMBIO_ESTADO_CITA','Cita ID 9 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',9,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:46:00'),(177,5,'2025-11-27 01:48:33','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:48:33'),(178,5,'2025-11-27 01:59:16','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:59:16'),(179,1,'2025-11-27 01:59:22','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:59:22'),(180,1,'2025-11-27 01:59:39','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',10,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:59:39'),(181,1,'2025-11-27 01:59:39','CREACION_CITA','Creada cita ID 10 paciente 1 doctor 2','CITAS',10,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:59:39'),(182,1,'2025-11-27 01:59:40','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 10','CITAS',10,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:59:40'),(183,1,'2025-11-27 01:59:41','CAMBIO_ESTADO_CITA','Cita ID 10 cambió de PROGRAMADA a CONFIRMADA','CITAS',10,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:59:41'),(184,1,'2025-11-27 01:59:41','CAMBIO_ESTADO_CITA','Cita 10 -> CONFIRMADA','CITAS',10,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:59:41'),(185,1,'2025-11-27 01:59:43','CAMBIO_ESTADO_CITA','Cita ID 10 cambió de CONFIRMADA a PRECLINICA','CITAS',10,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 01:59:43'),(186,1,'2025-11-27 01:59:43','CAMBIO_ESTADO_CITA','Cita 10 -> PRECLINICA','CITAS',10,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 01:59:43'),(187,1,'2025-11-27 02:00:02','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:00:02'),(188,1,'2025-11-27 02:00:07','ACCESO_ESPECIALIDADES','Acceso a la vista de especialidades','ESPECIALIDADES',NULL,'TBL_ESPECIALIDADES','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:00:07'),(189,1,'2025-11-27 02:00:32','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:00:32'),(190,1,'2025-11-27 02:00:46','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:00:46'),(191,5,'2025-11-27 02:03:11','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:03:11'),(192,1,'2025-11-27 02:03:16','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:03:16'),(193,1,'2025-11-27 02:03:27','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',11,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:03:27'),(194,1,'2025-11-27 02:03:27','CREACION_CITA','Creada cita ID 11 paciente 2 doctor 2','CITAS',11,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:03:27'),(195,1,'2025-11-27 02:03:28','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 11','CITAS',11,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:03:28'),(196,1,'2025-11-27 02:03:32','CAMBIO_ESTADO_CITA','Cita ID 11 cambió de PROGRAMADA a CONFIRMADA','CITAS',11,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:03:32'),(197,1,'2025-11-27 02:03:32','CAMBIO_ESTADO_CITA','Cita 11 -> CONFIRMADA','CITAS',11,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:03:32'),(198,1,'2025-11-27 02:03:51','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:03:51'),(199,1,'2025-11-27 02:03:55','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:03:55'),(200,1,'2025-11-27 02:04:36','CREACION_PRECLINICA','Creada preclínica ID 10 para cita 10','PRECLINICA',10,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:04:36'),(201,1,'2025-11-27 02:04:36','CAMBIO_ESTADO_CITA','Cita ID 10 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',10,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:04:36'),(202,1,'2025-11-27 02:04:36','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 10 -> CONSULTA_MEDICA tras crear preclínica 10','CITAS',10,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:04:36'),(203,1,'2025-11-27 02:04:43','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:04:43'),(204,1,'2025-11-27 02:05:13','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:05:13'),(205,2,'2025-11-27 02:05:59','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: non','CONSULTAS',10,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:05:59'),(206,1,'2025-11-27 02:05:59','CREACION_CONSULTA_MEDICA','Creada consulta ID 10 para cita 10','CONSULTA_MEDICA',10,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:05:59'),(207,1,'2025-11-27 02:05:59','CAMBIO_ESTADO_CITA','Cita ID 10 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',10,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:05:59'),(208,5,'2025-11-27 02:09:29','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:09:29'),(209,5,'2025-11-27 02:20:08','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:20:08'),(210,5,'2025-11-27 02:22:43','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:22:43'),(211,5,'2025-11-27 02:23:12','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:23:12'),(212,5,'2025-11-27 02:46:12','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:46:12'),(213,1,'2025-11-27 02:46:16','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:46:16'),(214,1,'2025-11-27 02:46:18','CAMBIO_ESTADO_CITA','Cita ID 11 cambió de CONFIRMADA a PRECLINICA','CITAS',11,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:46:18'),(215,1,'2025-11-27 02:46:18','CAMBIO_ESTADO_CITA','Cita 11 -> PRECLINICA','CITAS',11,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:46:18'),(216,1,'2025-11-27 02:46:23','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:46:23'),(217,1,'2025-11-27 02:46:51','CREACION_PRECLINICA','Creada preclínica ID 11 para cita 11','PRECLINICA',11,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:46:51'),(218,1,'2025-11-27 02:46:51','CAMBIO_ESTADO_CITA','Cita ID 11 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',11,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:46:51'),(219,1,'2025-11-27 02:46:51','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 11 -> CONSULTA_MEDICA tras crear preclínica 11','CITAS',11,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:46:51'),(220,1,'2025-11-27 02:46:59','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:46:59'),(221,2,'2025-11-27 02:47:24','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: kp','CONSULTAS',11,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:47:24'),(222,1,'2025-11-27 02:47:24','CREACION_CONSULTA_MEDICA','Creada consulta ID 11 para cita 11','CONSULTA_MEDICA',11,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:47:24'),(223,1,'2025-11-27 02:47:24','CAMBIO_ESTADO_CITA','Cita ID 11 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',11,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 02:47:24'),(224,1,'2025-11-27 02:49:27','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 02:49:27'),(225,5,'2025-11-27 03:00:48','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 03:00:48'),(226,5,'2025-11-27 10:08:56','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 10:08:56'),(227,5,'2025-11-27 10:21:54','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 10:21:54'),(228,1,'2025-11-27 10:25:42','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 10:25:42'),(229,5,'2025-11-27 10:51:45','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 10:51:45'),(230,5,'2025-11-27 10:53:02','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 10:53:02'),(231,5,'2025-11-27 11:10:07','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:10:07'),(232,5,'2025-11-27 11:18:11','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:18:11'),(233,5,'2025-11-27 11:21:03','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:21:03'),(234,1,'2025-11-27 11:23:57','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:23:57'),(235,1,'2025-11-27 11:24:04','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:24:04'),(236,5,'2025-11-27 11:24:55','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:24:55'),(237,5,'2025-11-27 11:30:41','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:30:41'),(238,5,'2025-11-27 11:33:29','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:33:29'),(239,5,'2025-11-27 11:55:06','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 11:55:06'),(240,5,'2025-11-27 12:21:09','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:21:09'),(241,1,'2025-11-27 12:21:59','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:21:59'),(242,5,'2025-11-27 12:28:16','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:28:16'),(243,1,'2025-11-27 12:28:45','CREACION_MEDICAMENTO','Medicamento agregado: e - Stock: 1','FARMACIA',3,'TBL_INVENTARIO_MEDICAMENTO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 12:28:45'),(244,NULL,'2025-11-27 12:28:53','ACTUALIZACION_MEDICAMENTO','Medicamento actualizado: e - Cambios: Estado: ACTIVO → INACTIVO; ','FARMACIA',3,'TBL_INVENTARIO_MEDICAMENTO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 12:28:53'),(245,1,'2025-11-27 12:29:35','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:29:35'),(246,1,'2025-11-27 12:31:02','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:31:02'),(247,1,'2025-11-27 12:31:56','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:31:56'),(248,5,'2025-11-27 12:32:27','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:32:27'),(249,1,'2025-11-27 12:33:31','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:33:31'),(250,1,'2025-11-27 12:33:55','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',12,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 12:33:55'),(251,1,'2025-11-27 12:33:55','CREACION_CITA','Creada cita ID 12 paciente 1 doctor 2','CITAS',12,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:33:55'),(252,1,'2025-11-27 12:33:56','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 12','CITAS',12,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:33:56'),(253,1,'2025-11-27 12:33:58','CAMBIO_ESTADO_CITA','Cita ID 12 cambió de PROGRAMADA a CONFIRMADA','CITAS',12,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 12:33:58'),(254,1,'2025-11-27 12:33:58','CAMBIO_ESTADO_CITA','Cita 12 -> CONFIRMADA','CITAS',12,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:33:58'),(255,1,'2025-11-27 12:34:02','CAMBIO_ESTADO_CITA','Cita ID 12 cambió de CONFIRMADA a PRECLINICA','CITAS',12,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 12:34:02'),(256,1,'2025-11-27 12:34:02','CAMBIO_ESTADO_CITA','Cita 12 -> PRECLINICA','CITAS',12,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:34:02'),(257,1,'2025-11-27 12:34:05','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:34:05'),(258,1,'2025-11-27 12:34:39','CREACION_PRECLINICA','Creada preclínica ID 12 para cita 12','PRECLINICA',12,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:34:39'),(259,1,'2025-11-27 12:34:39','CAMBIO_ESTADO_CITA','Cita ID 12 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',12,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 12:34:39'),(260,1,'2025-11-27 12:34:39','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 12 -> CONSULTA_MEDICA tras crear preclínica 12','CITAS',12,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:34:39'),(261,1,'2025-11-27 12:34:47','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:34:47'),(262,2,'2025-11-27 12:35:31','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: o','CONSULTAS',12,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 12:35:31'),(263,1,'2025-11-27 12:35:31','CREACION_CONSULTA_MEDICA','Creada consulta ID 12 para cita 12','CONSULTA_MEDICA',12,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 12:35:31'),(264,1,'2025-11-27 12:35:31','CAMBIO_ESTADO_CITA','Cita ID 12 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',12,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 12:35:31'),(265,5,'2025-11-27 13:42:48','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 13:42:48'),(266,5,'2025-11-27 13:51:43','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 13:51:43'),(267,5,'2025-11-27 13:59:29','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 13:59:29'),(268,5,'2025-11-27 14:02:15','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:02:15'),(269,5,'2025-11-27 14:07:04','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:07:04'),(270,5,'2025-11-27 14:09:45','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:09:45'),(271,1,'2025-11-27 14:10:09','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:10:09'),(272,1,'2025-11-27 14:10:26','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',13,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:10:26'),(273,1,'2025-11-27 14:10:26','CREACION_CITA','Creada cita ID 13 paciente 1 doctor 2','CITAS',13,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:10:26'),(274,1,'2025-11-27 14:10:27','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 13','CITAS',13,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:10:27'),(275,1,'2025-11-27 14:10:29','CAMBIO_ESTADO_CITA','Cita ID 13 cambió de PROGRAMADA a CONFIRMADA','CITAS',13,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:10:29'),(276,1,'2025-11-27 14:10:29','CAMBIO_ESTADO_CITA','Cita 13 -> CONFIRMADA','CITAS',13,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:10:29'),(277,1,'2025-11-27 14:10:31','CAMBIO_ESTADO_CITA','Cita ID 13 cambió de CONFIRMADA a PRECLINICA','CITAS',13,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:10:31'),(278,1,'2025-11-27 14:10:31','CAMBIO_ESTADO_CITA','Cita 13 -> PRECLINICA','CITAS',13,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:10:31'),(279,1,'2025-11-27 14:10:34','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:10:34'),(280,1,'2025-11-27 14:10:39','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:10:39'),(281,1,'2025-11-27 14:11:26','CREACION_PRECLINICA','Creada preclínica ID 13 para cita 13','PRECLINICA',13,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:11:26'),(282,1,'2025-11-27 14:11:26','CAMBIO_ESTADO_CITA','Cita ID 13 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',13,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:11:26'),(283,1,'2025-11-27 14:11:26','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 13 -> CONSULTA_MEDICA tras crear preclínica 13','CITAS',13,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:11:26'),(284,1,'2025-11-27 14:11:32','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:11:32'),(285,1,'2025-11-27 14:11:58','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:11:58'),(286,5,'2025-11-27 14:12:26','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:12:26'),(287,1,'2025-11-27 14:12:29','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:12:29'),(288,2,'2025-11-27 14:13:04','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: o','CONSULTAS',13,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:13:04'),(289,1,'2025-11-27 14:13:04','CREACION_CONSULTA_MEDICA','Creada consulta ID 13 para cita 13','CONSULTA_MEDICA',13,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:13:04'),(290,1,'2025-11-27 14:13:04','CAMBIO_ESTADO_CITA','Cita ID 13 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',13,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:13:04'),(291,5,'2025-11-27 14:16:12','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:16:12'),(292,1,'2025-11-27 14:16:50','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:16:50'),(293,1,'2025-11-27 14:16:53','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:16:53'),(294,1,'2025-11-27 14:16:57','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:16:57'),(295,1,'2025-11-27 14:17:09','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',14,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:17:09'),(296,1,'2025-11-27 14:17:09','CREACION_CITA','Creada cita ID 14 paciente 1 doctor 2','CITAS',14,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:17:09'),(297,1,'2025-11-27 14:17:10','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 14','CITAS',14,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:17:10'),(298,1,'2025-11-27 14:17:11','CAMBIO_ESTADO_CITA','Cita ID 14 cambió de PROGRAMADA a CONFIRMADA','CITAS',14,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:17:11'),(299,1,'2025-11-27 14:17:11','CAMBIO_ESTADO_CITA','Cita 14 -> CONFIRMADA','CITAS',14,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:17:11'),(300,1,'2025-11-27 14:17:13','CAMBIO_ESTADO_CITA','Cita ID 14 cambió de CONFIRMADA a PRECLINICA','CITAS',14,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:17:13'),(301,1,'2025-11-27 14:17:13','CAMBIO_ESTADO_CITA','Cita 14 -> PRECLINICA','CITAS',14,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:17:13'),(302,1,'2025-11-27 14:17:17','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:17:17'),(303,1,'2025-11-27 14:17:50','CREACION_PRECLINICA','Creada preclínica ID 14 para cita 14','PRECLINICA',14,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:17:50'),(304,1,'2025-11-27 14:17:50','CAMBIO_ESTADO_CITA','Cita ID 14 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',14,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:17:50'),(305,1,'2025-11-27 14:17:50','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 14 -> CONSULTA_MEDICA tras crear preclínica 14','CITAS',14,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:17:50'),(306,1,'2025-11-27 14:17:56','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:17:56'),(307,2,'2025-11-27 14:18:15','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: e','CONSULTAS',14,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:18:15'),(308,1,'2025-11-27 14:18:15','CREACION_CONSULTA_MEDICA','Creada consulta ID 14 para cita 14','CONSULTA_MEDICA',14,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:18:15'),(309,1,'2025-11-27 14:18:15','CAMBIO_ESTADO_CITA','Cita ID 14 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',14,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:18:15'),(310,5,'2025-11-27 14:20:19','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:20:19'),(311,1,'2025-11-27 14:20:47','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:20:47'),(312,1,'2025-11-27 14:20:59','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',15,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:20:59'),(313,1,'2025-11-27 14:20:59','CREACION_CITA','Creada cita ID 15 paciente 1 doctor 2','CITAS',15,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:20:59'),(314,1,'2025-11-27 14:21:00','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 15','CITAS',15,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:21:00'),(315,1,'2025-11-27 14:21:03','CAMBIO_ESTADO_CITA','Cita ID 15 cambió de PROGRAMADA a CONFIRMADA','CITAS',15,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:21:03'),(316,1,'2025-11-27 14:21:03','CAMBIO_ESTADO_CITA','Cita 15 -> CONFIRMADA','CITAS',15,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:21:03'),(317,1,'2025-11-27 14:21:05','CAMBIO_ESTADO_CITA','Cita ID 15 cambió de CONFIRMADA a PRECLINICA','CITAS',15,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:21:05'),(318,1,'2025-11-27 14:21:05','CAMBIO_ESTADO_CITA','Cita 15 -> PRECLINICA','CITAS',15,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:21:05'),(319,1,'2025-11-27 14:21:40','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:21:40'),(320,1,'2025-11-27 14:22:34','CREACION_PRECLINICA','Creada preclínica ID 15 para cita 15','PRECLINICA',15,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:22:34'),(321,1,'2025-11-27 14:22:34','CAMBIO_ESTADO_CITA','Cita ID 15 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',15,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:22:34'),(322,1,'2025-11-27 14:22:34','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 15 -> CONSULTA_MEDICA tras crear preclínica 15','CITAS',15,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:22:34'),(323,1,'2025-11-27 14:22:38','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:22:38'),(324,2,'2025-11-27 14:23:13','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: i','CONSULTAS',15,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:23:13'),(325,1,'2025-11-27 14:23:13','CREACION_CONSULTA_MEDICA','Creada consulta ID 15 para cita 15','CONSULTA_MEDICA',15,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:23:13'),(326,1,'2025-11-27 14:23:13','CAMBIO_ESTADO_CITA','Cita ID 15 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',15,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:23:13'),(327,5,'2025-11-27 14:27:40','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:27:40'),(328,1,'2025-11-27 14:27:56','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:27:56'),(329,1,'2025-11-27 14:28:09','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',16,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:28:09'),(330,1,'2025-11-27 14:28:09','CREACION_CITA','Creada cita ID 16 paciente 1 doctor 2','CITAS',16,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:09'),(331,1,'2025-11-27 14:28:10','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 16','CITAS',16,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:10'),(332,1,'2025-11-27 14:28:11','CAMBIO_ESTADO_CITA','Cita ID 16 cambió de PROGRAMADA a CONFIRMADA','CITAS',16,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:28:11'),(333,1,'2025-11-27 14:28:11','CAMBIO_ESTADO_CITA','Cita 16 -> CONFIRMADA','CITAS',16,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:11'),(334,1,'2025-11-27 14:28:13','CAMBIO_ESTADO_CITA','Cita ID 16 cambió de CONFIRMADA a PRECLINICA','CITAS',16,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:28:13'),(335,1,'2025-11-27 14:28:13','CAMBIO_ESTADO_CITA','Cita 16 -> PRECLINICA','CITAS',16,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:13'),(336,1,'2025-11-27 14:28:16','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:16'),(337,1,'2025-11-27 14:28:19','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:19'),(338,1,'2025-11-27 14:28:46','CREACION_PRECLINICA','Creada preclínica ID 16 para cita 16','PRECLINICA',16,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:46'),(339,1,'2025-11-27 14:28:46','CAMBIO_ESTADO_CITA','Cita ID 16 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',16,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:28:46'),(340,1,'2025-11-27 14:28:46','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 16 -> CONSULTA_MEDICA tras crear preclínica 16','CITAS',16,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:46'),(341,1,'2025-11-27 14:28:49','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:49'),(342,1,'2025-11-27 14:28:52','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:28:52'),(343,2,'2025-11-27 14:29:13','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: fg','CONSULTAS',16,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:29:13'),(344,1,'2025-11-27 14:29:13','CREACION_CONSULTA_MEDICA','Creada consulta ID 16 para cita 16','CONSULTA_MEDICA',16,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:29:13'),(345,1,'2025-11-27 14:29:13','CAMBIO_ESTADO_CITA','Cita ID 16 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',16,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:29:13'),(346,5,'2025-11-27 14:30:01','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:30:01'),(347,5,'2025-11-27 14:34:58','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:34:58'),(348,1,'2025-11-27 14:35:51','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:35:51'),(349,1,'2025-11-27 14:36:05','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',17,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:36:05'),(350,1,'2025-11-27 14:36:05','CREACION_CITA','Creada cita ID 17 paciente 2 doctor 2','CITAS',17,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:36:05'),(351,1,'2025-11-27 14:36:06','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 17','CITAS',17,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:36:06'),(352,1,'2025-11-27 14:36:08','CAMBIO_ESTADO_CITA','Cita ID 17 cambió de PROGRAMADA a CONFIRMADA','CITAS',17,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:36:08'),(353,1,'2025-11-27 14:36:08','CAMBIO_ESTADO_CITA','Cita 17 -> CONFIRMADA','CITAS',17,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:36:08'),(354,1,'2025-11-27 14:36:11','CAMBIO_ESTADO_CITA','Cita ID 17 cambió de CONFIRMADA a PRECLINICA','CITAS',17,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:36:11'),(355,1,'2025-11-27 14:36:11','CAMBIO_ESTADO_CITA','Cita 17 -> PRECLINICA','CITAS',17,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:36:11'),(356,1,'2025-11-27 14:36:16','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:36:16'),(357,1,'2025-11-27 14:36:50','CREACION_PRECLINICA','Creada preclínica ID 17 para cita 17','PRECLINICA',17,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:36:50'),(358,1,'2025-11-27 14:36:50','CAMBIO_ESTADO_CITA','Cita ID 17 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',17,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:36:50'),(359,1,'2025-11-27 14:36:50','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 17 -> CONSULTA_MEDICA tras crear preclínica 17','CITAS',17,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:36:50'),(360,1,'2025-11-27 14:36:54','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:36:54'),(361,2,'2025-11-27 14:37:25','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: jj','CONSULTAS',17,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:37:25'),(362,1,'2025-11-27 14:37:25','CREACION_CONSULTA_MEDICA','Creada consulta ID 17 para cita 17','CONSULTA_MEDICA',17,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:37:25'),(363,1,'2025-11-27 14:37:25','CAMBIO_ESTADO_CITA','Cita ID 17 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',17,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 14:37:25'),(364,5,'2025-11-27 14:54:59','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 14:54:59'),(365,5,'2025-11-27 15:06:05','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:06:05'),(366,5,'2025-11-27 15:07:40','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:07:40'),(367,5,'2025-11-27 15:08:39','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:08:39'),(368,5,'2025-11-27 15:10:59','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:10:59'),(369,5,'2025-11-27 15:13:14','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:13:14'),(370,1,'2025-11-27 15:21:37','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:21:37'),(371,5,'2025-11-27 15:40:19','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:40:19'),(372,1,'2025-11-27 15:40:34','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:40:34'),(373,1,'2025-11-27 15:40:48','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',18,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 15:40:48'),(374,1,'2025-11-27 15:40:48','CREACION_CITA','Creada cita ID 18 paciente 2 doctor 2','CITAS',18,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:40:48'),(375,1,'2025-11-27 15:40:49','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 18','CITAS',18,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:40:49'),(376,1,'2025-11-27 15:40:51','CAMBIO_ESTADO_CITA','Cita ID 18 cambió de PROGRAMADA a CONFIRMADA','CITAS',18,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 15:40:51'),(377,1,'2025-11-27 15:40:51','CAMBIO_ESTADO_CITA','Cita 18 -> CONFIRMADA','CITAS',18,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:40:51'),(378,1,'2025-11-27 15:40:52','CAMBIO_ESTADO_CITA','Cita ID 18 cambió de CONFIRMADA a PRECLINICA','CITAS',18,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 15:40:52'),(379,1,'2025-11-27 15:40:52','CAMBIO_ESTADO_CITA','Cita 18 -> PRECLINICA','CITAS',18,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:40:52'),(380,1,'2025-11-27 15:40:55','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:40:55'),(381,1,'2025-11-27 15:41:22','CREACION_PRECLINICA','Creada preclínica ID 18 para cita 18','PRECLINICA',18,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:41:22'),(382,1,'2025-11-27 15:41:22','CAMBIO_ESTADO_CITA','Cita ID 18 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',18,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 15:41:22'),(383,1,'2025-11-27 15:41:22','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 18 -> CONSULTA_MEDICA tras crear preclínica 18','CITAS',18,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:41:22'),(384,1,'2025-11-27 15:41:27','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:41:27'),(385,2,'2025-11-27 15:41:59','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: i','CONSULTAS',18,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 15:41:59'),(386,1,'2025-11-27 15:41:59','CREACION_CONSULTA_MEDICA','Creada consulta ID 18 para cita 18','CONSULTA_MEDICA',18,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:41:59'),(387,1,'2025-11-27 15:41:59','CAMBIO_ESTADO_CITA','Cita ID 18 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',18,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 15:41:59'),(388,5,'2025-11-27 15:43:13','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 15:43:13'),(389,5,'2025-11-27 16:01:04','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:01:04'),(390,1,'2025-11-27 16:04:54','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:04:54'),(391,1,'2025-11-27 16:05:15','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',19,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:05:15'),(392,1,'2025-11-27 16:05:15','CREACION_CITA','Creada cita ID 19 paciente 1 doctor 2','CITAS',19,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:05:15'),(393,1,'2025-11-27 16:05:16','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 19','CITAS',19,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:05:16'),(394,1,'2025-11-27 16:05:19','CAMBIO_ESTADO_CITA','Cita ID 19 cambió de PROGRAMADA a CONFIRMADA','CITAS',19,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:05:19'),(395,1,'2025-11-27 16:05:19','CAMBIO_ESTADO_CITA','Cita 19 -> CONFIRMADA','CITAS',19,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:05:19'),(396,1,'2025-11-27 16:05:27','CAMBIO_ESTADO_CITA','Cita ID 19 cambió de CONFIRMADA a PRECLINICA','CITAS',19,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:05:27'),(397,1,'2025-11-27 16:05:27','CAMBIO_ESTADO_CITA','Cita 19 -> PRECLINICA','CITAS',19,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:05:27'),(398,1,'2025-11-27 16:05:35','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:05:35'),(399,1,'2025-11-27 16:06:22','CREACION_PRECLINICA','Creada preclínica ID 19 para cita 19','PRECLINICA',19,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:06:22'),(400,1,'2025-11-27 16:06:22','CAMBIO_ESTADO_CITA','Cita ID 19 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',19,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:06:22'),(401,1,'2025-11-27 16:06:22','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 19 -> CONSULTA_MEDICA tras crear preclínica 19','CITAS',19,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:06:22'),(402,1,'2025-11-27 16:06:44','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:06:44'),(403,2,'2025-11-27 16:07:02','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: o','CONSULTAS',19,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:07:02'),(404,1,'2025-11-27 16:07:02','CREACION_CONSULTA_MEDICA','Creada consulta ID 19 para cita 19','CONSULTA_MEDICA',19,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:07:02'),(405,1,'2025-11-27 16:07:02','CAMBIO_ESTADO_CITA','Cita ID 19 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',19,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:07:02'),(406,5,'2025-11-27 16:07:23','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:07:23'),(407,5,'2025-11-27 16:23:34','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:23:34'),(408,1,'2025-11-27 16:23:52','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:23:52'),(409,1,'2025-11-27 16:24:04','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',20,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:24:04'),(410,1,'2025-11-27 16:24:04','CREACION_CITA','Creada cita ID 20 paciente 1 doctor 2','CITAS',20,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:24:04'),(411,1,'2025-11-27 16:24:05','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 20','CITAS',20,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:24:05'),(412,1,'2025-11-27 16:24:06','CAMBIO_ESTADO_CITA','Cita ID 20 cambió de PROGRAMADA a CONFIRMADA','CITAS',20,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:24:06'),(413,1,'2025-11-27 16:24:06','CAMBIO_ESTADO_CITA','Cita 20 -> CONFIRMADA','CITAS',20,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:24:06'),(414,1,'2025-11-27 16:24:09','CAMBIO_ESTADO_CITA','Cita ID 20 cambió de CONFIRMADA a PRECLINICA','CITAS',20,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:24:09'),(415,1,'2025-11-27 16:24:09','CAMBIO_ESTADO_CITA','Cita 20 -> PRECLINICA','CITAS',20,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:24:09'),(416,1,'2025-11-27 16:24:22','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:24:22'),(417,1,'2025-11-27 16:24:48','CREACION_PRECLINICA','Creada preclínica ID 20 para cita 20','PRECLINICA',20,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:24:48'),(418,1,'2025-11-27 16:24:48','CAMBIO_ESTADO_CITA','Cita ID 20 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',20,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:24:48'),(419,1,'2025-11-27 16:24:48','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 20 -> CONSULTA_MEDICA tras crear preclínica 20','CITAS',20,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:24:48'),(420,1,'2025-11-27 16:24:53','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:24:53'),(421,2,'2025-11-27 16:25:11','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: kk','CONSULTAS',20,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:25:11'),(422,1,'2025-11-27 16:25:11','CREACION_CONSULTA_MEDICA','Creada consulta ID 20 para cita 20','CONSULTA_MEDICA',20,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:25:11'),(423,1,'2025-11-27 16:25:11','CAMBIO_ESTADO_CITA','Cita ID 20 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',20,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:25:11'),(424,5,'2025-11-27 16:25:54','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:25:54'),(425,1,'2025-11-27 16:25:57','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:25:57'),(426,1,'2025-11-27 16:26:07','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',21,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:26:07'),(427,1,'2025-11-27 16:26:07','CREACION_CITA','Creada cita ID 21 paciente 1 doctor 2','CITAS',21,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:26:07'),(428,1,'2025-11-27 16:26:09','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 21','CITAS',21,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:26:09'),(429,1,'2025-11-27 16:26:10','CAMBIO_ESTADO_CITA','Cita ID 21 cambió de PROGRAMADA a CONFIRMADA','CITAS',21,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:26:10'),(430,1,'2025-11-27 16:26:10','CAMBIO_ESTADO_CITA','Cita 21 -> CONFIRMADA','CITAS',21,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:26:10'),(431,1,'2025-11-27 16:26:12','CAMBIO_ESTADO_CITA','Cita ID 21 cambió de CONFIRMADA a PRECLINICA','CITAS',21,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:26:12'),(432,1,'2025-11-27 16:26:12','CAMBIO_ESTADO_CITA','Cita 21 -> PRECLINICA','CITAS',21,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:26:12'),(433,1,'2025-11-27 16:26:15','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:26:15'),(434,1,'2025-11-27 16:26:39','CREACION_PRECLINICA','Creada preclínica ID 21 para cita 21','PRECLINICA',21,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:26:39'),(435,1,'2025-11-27 16:26:39','CAMBIO_ESTADO_CITA','Cita ID 21 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',21,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:26:39'),(436,1,'2025-11-27 16:26:39','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 21 -> CONSULTA_MEDICA tras crear preclínica 21','CITAS',21,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:26:39'),(437,1,'2025-11-27 16:26:45','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:26:45'),(438,2,'2025-11-27 16:27:10','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: kk','CONSULTAS',21,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:27:10'),(439,1,'2025-11-27 16:27:10','CREACION_CONSULTA_MEDICA','Creada consulta ID 21 para cita 21','CONSULTA_MEDICA',21,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:27:10'),(440,1,'2025-11-27 16:27:10','CAMBIO_ESTADO_CITA','Cita ID 21 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',21,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 16:27:10'),(441,5,'2025-11-27 16:40:49','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:40:49'),(442,5,'2025-11-27 16:50:55','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 16:50:55'),(443,1,'2025-11-27 17:18:54','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:18:54'),(444,1,'2025-11-27 17:19:11','CREACION_CITA','Cita creada para paciente ID: 2 con doctor ID: 2 - PROGRAMADA','CITAS',22,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 17:19:11'),(445,1,'2025-11-27 17:19:11','CREACION_CITA','Creada cita ID 22 paciente 2 doctor 2','CITAS',22,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:19:11'),(446,1,'2025-11-27 17:19:12','ENVIO_EMAIL_CITA','Email de confirmación enviado a juan.lopez@email.com para cita ID 22','CITAS',22,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:19:12'),(447,1,'2025-11-27 17:19:13','CAMBIO_ESTADO_CITA','Cita ID 22 cambió de PROGRAMADA a CONFIRMADA','CITAS',22,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 17:19:13'),(448,1,'2025-11-27 17:19:13','CAMBIO_ESTADO_CITA','Cita 22 -> CONFIRMADA','CITAS',22,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:19:13'),(449,1,'2025-11-27 17:19:19','CAMBIO_ESTADO_CITA','Cita ID 22 cambió de CONFIRMADA a PRECLINICA','CITAS',22,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 17:19:19'),(450,1,'2025-11-27 17:19:19','CAMBIO_ESTADO_CITA','Cita 22 -> PRECLINICA','CITAS',22,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:19:19'),(451,1,'2025-11-27 17:19:25','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:19:25'),(452,1,'2025-11-27 17:20:00','CREACION_PRECLINICA','Creada preclínica ID 22 para cita 22','PRECLINICA',22,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:20:00'),(453,1,'2025-11-27 17:20:00','CAMBIO_ESTADO_CITA','Cita ID 22 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',22,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 17:20:00'),(454,1,'2025-11-27 17:20:00','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 22 -> CONSULTA_MEDICA tras crear preclínica 22','CITAS',22,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:20:00'),(455,1,'2025-11-27 17:20:06','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:20:06'),(456,2,'2025-11-27 17:20:35','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 2 - Diagnóstico: k','CONSULTAS',22,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 17:20:35'),(457,1,'2025-11-27 17:20:35','CREACION_CONSULTA_MEDICA','Creada consulta ID 22 para cita 22','CONSULTA_MEDICA',22,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:20:35'),(458,1,'2025-11-27 17:20:35','CAMBIO_ESTADO_CITA','Cita ID 22 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',22,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 17:20:35'),(459,5,'2025-11-27 17:21:52','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:21:52'),(460,5,'2025-11-27 17:35:28','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:35:28'),(461,5,'2025-11-27 17:43:56','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:43:56'),(462,5,'2025-11-27 17:46:20','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:46:20'),(463,5,'2025-11-27 17:48:08','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:48:08'),(464,5,'2025-11-27 17:49:40','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:49:40'),(465,5,'2025-11-27 17:57:39','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 17:57:39'),(466,5,'2025-11-27 18:41:29','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 18:41:29'),(467,5,'2025-11-27 18:42:42','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 18:42:42'),(468,5,'2025-11-27 18:50:39','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 18:50:39'),(469,5,'2025-11-27 19:15:47','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:15:47'),(470,5,'2025-11-27 19:23:09','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:23:09'),(471,NULL,'2025-11-27 19:25:03','ACTUALIZACION_MEDICAMENTO','Medicamento actualizado: Antibióticos - Cambios: Estado: INACTIVO → ACTIVO; ','FARMACIA',3,'TBL_INVENTARIO_MEDICAMENTO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 19:25:03'),(472,1,'2025-11-27 19:27:30','ACTUALIZACION_MEDICAMENTO','Medicamento actualizado: Antibióticos - Cambios: Stock: 1 → 35; ','FARMACIA',3,'TBL_INVENTARIO_MEDICAMENTO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 19:27:30'),(473,5,'2025-11-27 19:30:28','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:30:28'),(474,1,'2025-11-27 19:30:55','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:30:55'),(475,1,'2025-11-27 19:31:11','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',23,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 19:31:11'),(476,1,'2025-11-27 19:31:11','CREACION_CITA','Creada cita ID 23 paciente 1 doctor 2','CITAS',23,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:31:11'),(477,1,'2025-11-27 19:31:13','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 23','CITAS',23,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:31:13'),(478,1,'2025-11-27 19:31:14','CAMBIO_ESTADO_CITA','Cita ID 23 cambió de PROGRAMADA a CONFIRMADA','CITAS',23,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 19:31:14'),(479,1,'2025-11-27 19:31:14','CAMBIO_ESTADO_CITA','Cita 23 -> CONFIRMADA','CITAS',23,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:31:14'),(480,1,'2025-11-27 19:31:17','CAMBIO_ESTADO_CITA','Cita ID 23 cambió de CONFIRMADA a PRECLINICA','CITAS',23,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 19:31:17'),(481,1,'2025-11-27 19:31:17','CAMBIO_ESTADO_CITA','Cita 23 -> PRECLINICA','CITAS',23,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:31:17'),(482,1,'2025-11-27 19:31:22','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:31:22'),(483,1,'2025-11-27 19:31:50','CREACION_PRECLINICA','Creada preclínica ID 23 para cita 23','PRECLINICA',23,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:31:50'),(484,1,'2025-11-27 19:31:50','CAMBIO_ESTADO_CITA','Cita ID 23 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',23,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 19:31:50'),(485,1,'2025-11-27 19:31:50','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 23 -> CONSULTA_MEDICA tras crear preclínica 23','CITAS',23,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:31:50'),(486,1,'2025-11-27 19:31:55','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:31:55'),(487,2,'2025-11-27 19:32:15','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: j','CONSULTAS',23,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 19:32:15'),(488,1,'2025-11-27 19:32:15','CREACION_CONSULTA_MEDICA','Creada consulta ID 23 para cita 23','CONSULTA_MEDICA',23,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-27 19:32:15'),(489,1,'2025-11-27 19:32:15','CAMBIO_ESTADO_CITA','Cita ID 23 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',23,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-27 19:32:15'),(490,5,'2025-11-28 00:20:28','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 00:20:28'),(491,NULL,'2025-11-28 02:39:32','ACTUALIZACION_MEDICAMENTO','Medicamento actualizado: Antibióticos - Cambios: Stock: 35 → 40; ','FARMACIA',3,'TBL_INVENTARIO_MEDICAMENTO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 02:39:32'),(492,1,'2025-11-28 02:44:57','ACTUALIZACION_MEDICAMENTO','Medicamento actualizado: LOSARTAN - Cambios: Stock: 100 → 102; ','FARMACIA',1,'TBL_INVENTARIO_MEDICAMENTO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 02:44:57'),(493,5,'2025-11-28 14:09:06','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:09:06'),(494,1,'2025-11-28 14:09:40','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:09:40'),(495,NULL,'2025-11-28 14:26:27','ACTUALIZACION_USUARIO','Usuario actualizado: DR.Denis - Cambios: Actualización general del usuario','USUARIOS',2,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:26:27'),(496,2,'2025-11-28 14:26:27','ACTUALIZACION','Modificación de usuario: USUARIO: \'DR.GARCIA\' → \'DR.Denis\'; NOMBRE: \'DR. ROBERTO GARCÍA LÓPEZ\' → \'DR. DENIS SANDOVAL\'','USUARIOS',2,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'1','2025-11-28 14:26:27'),(497,5,'2025-11-28 14:28:00','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:28:00'),(498,1,'2025-11-28 14:28:26','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:28:26'),(499,1,'2025-11-28 14:31:31','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:31:31'),(500,1,'2025-11-28 14:31:44','CREACION_CITA','Cita creada para paciente ID: 1 con doctor ID: 2 - PROGRAMADA','CITAS',24,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:31:44'),(501,1,'2025-11-28 14:31:44','CREACION_CITA','Creada cita ID 24 paciente 1 doctor 2','CITAS',24,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:31:44'),(502,1,'2025-11-28 14:31:46','ENVIO_EMAIL_CITA','Email de confirmación enviado a maria.garcia@email.com para cita ID 24','CITAS',24,'TBL_MS_USUARIO','127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:31:46'),(503,1,'2025-11-28 14:31:47','CAMBIO_ESTADO_CITA','Cita ID 24 cambió de PROGRAMADA a CONFIRMADA','CITAS',24,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:31:47'),(504,1,'2025-11-28 14:31:47','CAMBIO_ESTADO_CITA','Cita 24 -> CONFIRMADA','CITAS',24,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:31:47'),(505,1,'2025-11-28 14:31:49','CAMBIO_ESTADO_CITA','Cita ID 24 cambió de CONFIRMADA a PRECLINICA','CITAS',24,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:31:49'),(506,1,'2025-11-28 14:31:49','CAMBIO_ESTADO_CITA','Cita 24 -> PRECLINICA','CITAS',24,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:31:49'),(507,1,'2025-11-28 14:31:52','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:31:52'),(508,1,'2025-11-28 14:32:26','CREACION_PRECLINICA','Creada preclínica ID 24 para cita 24','PRECLINICA',24,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:32:26'),(509,1,'2025-11-28 14:32:26','CAMBIO_ESTADO_CITA','Cita ID 24 cambió de PRECLINICA a CONSULTA_MEDICA','CITAS',24,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:32:26'),(510,1,'2025-11-28 14:32:26','CAMBIO_ESTADO_CITA_POR_PRECLINICA','Cita 24 -> CONSULTA_MEDICA tras crear preclínica 24','CITAS',24,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:32:26'),(511,1,'2025-11-28 14:32:29','ACCESO_CONSULTA_MEDICA','Acceso a la vista de consulta médica','CONSULTA_MEDICA',NULL,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:32:29'),(512,2,'2025-11-28 14:32:52','REGISTRO_CONSULTA','Consulta médica registrada para paciente ID: 1 - Diagnóstico: kk','CONSULTAS',24,'TBL_CONSULTA_MEDICA',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:32:52'),(513,1,'2025-11-28 14:32:52','CREACION_CONSULTA_MEDICA','Creada consulta ID 24 para cita 24','CONSULTA_MEDICA',24,'TBL_CONSULTA_MEDICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:32:52'),(514,1,'2025-11-28 14:32:52','CAMBIO_ESTADO_CITA','Cita ID 24 cambió de CONSULTA_MEDICA a FINALIZADA','CITAS',24,'TBL_CITAS',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:32:52'),(515,5,'2025-11-28 14:35:01','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:35:01'),(516,NULL,'2025-11-28 14:43:15','ACTUALIZACION_USUARIO','Usuario actualizado: usuario - Cambios: Actualización general del usuario','USUARIOS',5,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:43:15'),(517,5,'2025-11-28 14:45:10','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:45:10'),(518,NULL,'2025-11-28 14:47:16','ACTUALIZACION_USUARIO','Usuario actualizado: DR.Denis - Cambios: Actualización general del usuario','USUARIOS',2,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 14:47:16'),(519,2,'2025-11-28 14:47:16','ACTUALIZACION','Modificación de usuario: NOMBRE: \'DR. DENIS SANDOVAL\' → \'DENIS SANDOVAL\'','USUARIOS',2,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'1','2025-11-28 14:47:16'),(520,5,'2025-11-28 14:49:07','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 14:49:07'),(521,NULL,'2025-11-28 15:08:14','CREACION_USUARIO','Nuevo usuario creado: DR Victor Martinez - Victor Martinez Alvarado','USUARIOS',6,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 15:08:14'),(522,6,'2025-11-28 15:08:14','REGISTRO','Nuevo usuario registrado: DR Victor Martinez','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:08:14'),(523,NULL,'2025-11-28 15:09:46','CREACION_USUARIO','Nuevo usuario creado: DrFrancisco Amaya - Francisco Amaya','USUARIOS',7,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 15:09:46'),(524,7,'2025-11-28 15:09:46','REGISTRO','Nuevo usuario registrado: DrFrancisco Amaya','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:09:46'),(525,NULL,'2025-11-28 15:12:01','CREACION_USUARIO','Nuevo usuario creado: DRMoisésHenriquez  - Moisés Henriquez ','USUARIOS',8,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 15:12:01'),(526,8,'2025-11-28 15:12:01','REGISTRO','Nuevo usuario registrado: DRMoisésHenriquez ','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:12:01'),(527,NULL,'2025-11-28 15:13:54','CREACION_USUARIO','Nuevo usuario creado: DRACelestePinto - Celeste Pinto','USUARIOS',9,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 15:13:54'),(528,9,'2025-11-28 15:13:54','REGISTRO','Nuevo usuario registrado: DRACelestePinto','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:13:54'),(529,5,'2025-11-28 15:14:02','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:14:02'),(530,1,'2025-11-28 15:14:54','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:14:54'),(531,NULL,'2025-11-28 15:16:58','ACTUALIZACION_USUARIO','Usuario actualizado: DRACelestePinto - Cambios: Actualización general del usuario','USUARIOS',9,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 15:16:58'),(532,NULL,'2025-11-28 15:17:05','ACTUALIZACION_USUARIO','Usuario actualizado: DRMoisésHenriquez  - Cambios: Actualización general del usuario','USUARIOS',8,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 15:17:05'),(533,NULL,'2025-11-28 15:17:11','ACTUALIZACION_USUARIO','Usuario actualizado: DrFrancisco Amaya - Cambios: Actualización general del usuario','USUARIOS',7,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 15:17:11'),(534,NULL,'2025-11-28 15:17:20','ACTUALIZACION_USUARIO','Usuario actualizado: DR Victor Martinez - Cambios: Actualización general del usuario','USUARIOS',6,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 15:17:20'),(535,5,'2025-11-28 15:17:38','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:17:38'),(536,1,'2025-11-28 15:17:40','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:17:40'),(537,3,'2025-11-28 15:21:44','ELIMINACION','Eliminación permanente del usuario: ENF.ROSA','USUARIOS',3,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'1','2025-11-28 15:21:44'),(538,3,'2025-11-28 15:21:47','ELIMINACION','Eliminación permanente del usuario: ENF.ROSA','USUARIOS',3,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'1','2025-11-28 15:21:47'),(539,3,'2025-11-28 15:21:49','ELIMINACION','Eliminación permanente del usuario: ENF.ROSA','USUARIOS',3,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'1','2025-11-28 15:21:49'),(540,5,'2025-11-28 15:41:22','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 15:41:22'),(541,1,'2025-11-28 16:02:59','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:02:59'),(542,5,'2025-11-28 16:12:48','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:12:48'),(543,5,'2025-11-28 16:13:43','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:13:43'),(544,5,'2025-11-28 16:32:00','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:32:00'),(545,1,'2025-11-28 16:34:07','ACCESO_CITAS','Acceso a la vista de citas','CITAS',NULL,'TBL_CITAS','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:34:07'),(546,1,'2025-11-28 16:35:39','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:35:39'),(547,1,'2025-11-28 16:36:04','ACCESO_PRECLINICA','Acceso a la vista de preclínica','PRECLINICA',NULL,'TBL_PRECLINICA','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:36:04'),(548,1,'2025-11-28 16:40:02','ACCESO_ESPECIALIDADES','Acceso a la vista de especialidades','ESPECIALIDADES',NULL,'TBL_ESPECIALIDADES','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:40:02'),(549,1,'2025-11-28 16:40:23','ACTUALIZACION_ESPECIALIDAD','Actualizada especialidad ID 4: CARDIOLOGÍA','ESPECIALIDADES',4,'TBL_ESPECIALIDADES','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:40:23'),(550,5,'2025-11-28 16:41:06','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:41:06'),(551,1,'2025-11-28 16:46:18','ACCESO_ESPECIALIDADES','Acceso a la vista de especialidades','ESPECIALIDADES',NULL,'TBL_ESPECIALIDADES','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:46:18'),(552,1,'2025-11-28 16:55:32','ACCESO_ESPECIALIDADES','Acceso a la vista de especialidades','ESPECIALIDADES',NULL,'TBL_ESPECIALIDADES','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36','EXITO',NULL,'SISTEMA_WEB','2025-11-28 16:55:32'),(553,4,'2025-11-28 16:56:20','ELIMINACION','Eliminación permanente del usuario: RECEP.ANA','USUARIOS',4,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'1','2025-11-28 16:56:20'),(554,5,'2025-11-28 17:49:18','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 17:49:18'),(555,5,'2025-11-28 19:50:51','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 19:50:51'),(556,5,'2025-11-28 19:54:34','LOGIN','Inicio de sesión exitoso','AUTENTICACIÓN',NULL,NULL,'127.0.0.1','Sistema','EXITO',NULL,'SISTEMA_WEB','2025-11-28 19:54:34'),(557,NULL,'2025-11-28 19:55:48','ACTUALIZACION_USUARIO','Usuario actualizado: administrador - Cambios: Actualización general del usuario','USUARIOS',5,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 19:55:48'),(558,5,'2025-11-28 19:55:48','ACTUALIZACION','Modificación de usuario: USUARIO: \'usuario\' → \'administrador\'; NOMBRE: \'Eduar Dominguez\' → \'ADMINISTRADOR DEL SISTEMA\'','USUARIOS',5,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'1','2025-11-28 19:55:48'),(559,NULL,'2025-11-28 19:58:35','ACTUALIZACION_USUARIO','Usuario actualizado: administrador - Cambios: Actualización general del usuario','USUARIOS',5,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 19:58:35'),(560,NULL,'2025-11-28 19:59:24','ACTUALIZACION_USUARIO','Usuario actualizado: administrador - Cambios: Actualización general del usuario','USUARIOS',5,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 19:59:24'),(561,NULL,'2025-11-28 19:59:57','ACTUALIZACION_USUARIO','Usuario actualizado: administrador - Cambios: Actualización general del usuario','USUARIOS',5,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 19:59:57'),(562,NULL,'2025-11-28 20:02:04','ACTUALIZACION_USUARIO','Usuario actualizado: administrador - Cambios: Actualización general del usuario','USUARIOS',5,'TBL_MS_USUARIO',NULL,NULL,'EXITO',NULL,'TRIGGER','2025-11-28 20:02:04');
/*!40000 ALTER TABLE `tbl_ms_bitacora` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_ms_hist_contraseña`
--

DROP TABLE IF EXISTS `tbl_ms_hist_contraseña`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_ms_hist_contraseña` (
  `ID_HIST` int NOT NULL AUTO_INCREMENT,
  `ID_USUARIO` int NOT NULL,
  `CONTRASENA` varchar(255) NOT NULL,
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_HIST`),
  KEY `idx_hist_usuario` (`ID_USUARIO`),
  CONSTRAINT `tbl_ms_hist_contraseña_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_ms_hist_contraseña`
--

LOCK TABLES `tbl_ms_hist_contraseña` WRITE;
/*!40000 ALTER TABLE `tbl_ms_hist_contraseña` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_ms_hist_contraseña` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_ms_parametros`
--

DROP TABLE IF EXISTS `tbl_ms_parametros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_ms_parametros` (
  `ID_PARAMETRO` int NOT NULL AUTO_INCREMENT,
  `PARAMETRO` varchar(100) NOT NULL,
  `VALOR` varchar(255) NOT NULL,
  `DESCRIPCION` varchar(500) DEFAULT NULL,
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_PARAMETRO`),
  UNIQUE KEY `PARAMETRO` (`PARAMETRO`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_ms_parametros`
--

LOCK TABLES `tbl_ms_parametros` WRITE;
/*!40000 ALTER TABLE `tbl_ms_parametros` DISABLE KEYS */;
INSERT INTO `tbl_ms_parametros` VALUES (1,'ADMIN_INTENTOS_INVALIDOS','3','NÚMERO MÁXIMO DE INTENTOS DE LOGIN FALLIDOS PERMITIDOS','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(2,'ADMIN_PREGUNTAS','3','NÚMERO DE PREGUNTAS DE SEGURIDAD REQUERIDAS','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(3,'ADMIN_CORREO','correo@dominio.com','CORREO ELECTRÓNICO PARA ENVÍO DE NOTIFICACIONES','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(4,'ADMIN_CPUERTO','9999','PUERTO PARA CONFIGURACIÓN DEL SERVIDOR','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(5,'ADMIN_CUSER','USUARIO','USUARIO PARA CONFIGURACIÓN DEL SERVIDOR','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(6,'ADMIN_CPASS','PASSWORD','CONTRASEÑA PARA CONFIGURACIÓN DEL SERVIDOR','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(7,'ADMIN_VIGENCIA','30','DÍAS DE VIGENCIA DE LA CONTRASEÑA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(8,'ADMIN_DIAS_VIGENCIA','360','DÍAS DE VIGENCIA DE LA CUENTA DE USUARIO','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(9,'IMPUESTO','15','PORCENTAJE DE IMPUESTO APLICABLE','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(10,'SYS_NOMBRE','SISTEMA ROCA MAYA','NOMBRE DEL SISTEMA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(11,'MIN_CONTRASEÑA','8','LONGITUD MÍNIMA DE LA CONTRASEÑA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(12,'MAX_CONTRASEÑA','15','LONGITUD MÁXIMA DE LA CONTRASEÑA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(13,'BITACORA_RETENCION_DIAS','365','DÍAS DE RETENCIÓN DE REGISTROS EN BITÁCORA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(14,'BITACORA_LOG_ERRORS','SI','REGISTRAR ERRORES EN BITÁCORA (SI/NO)','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(15,'BITACORA_LOG_LOGINS','SI','REGISTRAR INICIOS DE SESIÓN EN BITÁCORA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(16,'2FA_MAX_INTENTOS','3','MÁXIMO DE INTENTOS FALLIDOS DE CÓDIGO 2FA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(17,'2FA_TIEMPO_BLOQUEO_MIN','30','MINUTOS DE BLOQUEO POR INTENTOS FALLIDOS 2FA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(18,'2FA_OBLIGATORIO_ADMIN','SI','2FA OBLIGATORIO PARA USUARIOS ADMINISTRADORES','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL);
/*!40000 ALTER TABLE `tbl_ms_parametros` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_PARAMETROS_UPDATE` AFTER UPDATE ON `tbl_ms_parametros` FOR EACH ROW BEGIN
    DECLARE v_id_usuario_modificador INT;
    
    IF OLD.VALOR != NEW.VALOR THEN
        -- Buscar ID del usuario modificador
        SELECT COALESCE(ID_USUARIO, 1) INTO v_id_usuario_modificador 
        FROM TBL_MS_USUARIO 
        WHERE USUARIO = COALESCE(NEW.USUARIO_MODIFICACION, 'SISTEMA')
        LIMIT 1;
        
        CALL SP_REGISTRAR_BITACORA(
            v_id_usuario_modificador,
            'ACTUALIZACION_PARAMETRO',
            CONCAT('Parámetro actualizado: ', NEW.PARAMETRO, ' - Valor: ', OLD.VALOR, ' → ', NEW.VALOR),
            'CONFIGURACION',
            NEW.ID_PARAMETRO,
            'TBL_MS_PARAMETROS',
            NULL, NULL, 'EXITO', NULL,
            'TRIGGER'
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_ms_roles`
--

DROP TABLE IF EXISTS `tbl_ms_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_ms_roles` (
  `ID_ROL` int NOT NULL AUTO_INCREMENT,
  `ROL` varchar(50) NOT NULL,
  `DESCRIPCION` varchar(255) DEFAULT NULL,
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_ROL`),
  UNIQUE KEY `ROL` (`ROL`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_ms_roles`
--

LOCK TABLES `tbl_ms_roles` WRITE;
/*!40000 ALTER TABLE `tbl_ms_roles` DISABLE KEYS */;
INSERT INTO `tbl_ms_roles` VALUES (1,'ADMINISTRADOR','USUARIO CON ACCESO COMPLETO AL SISTEMA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(2,'DOCTOR','MÉDICO CON PERMISOS PARA CONSULTAS Y RECETAS','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(3,'ENFERMERA','PERSONAL DE ENFERMERÍA PARA PRECLÍNICA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(4,'RECEPCIONISTA','PERSONAL DE RECEPCIÓN Y CITAS','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL),(5,'PACIENTE','USUARIO PACIENTE DEL SISTEMA','2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL);
/*!40000 ALTER TABLE `tbl_ms_roles` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_ROLES_INSERT` AFTER INSERT ON `tbl_ms_roles` FOR EACH ROW BEGIN
    DECLARE v_id_usuario_creador INT;
    
    -- Buscar ID del usuario creador
    SELECT COALESCE(ID_USUARIO, 1) INTO v_id_usuario_creador 
    FROM TBL_MS_USUARIO 
    WHERE USUARIO = COALESCE(NEW.USUARIO_CREACION, 'SISTEMA')
    LIMIT 1;
    
    CALL SP_REGISTRAR_BITACORA(
        v_id_usuario_creador,
        'CREACION_ROL',
        CONCAT('Nuevo rol creado: ', NEW.ROL),
        'ROLES',
        NEW.ID_ROL,
        'TBL_MS_ROLES',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_ms_usuario`
--

DROP TABLE IF EXISTS `tbl_ms_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_ms_usuario` (
  `ID_USUARIO` int NOT NULL AUTO_INCREMENT,
  `USUARIO` varchar(50) NOT NULL,
  `NOMBRE_USUARIO` varchar(100) NOT NULL,
  `ESTADO` varchar(20) NOT NULL DEFAULT 'NUEVO',
  `CONTRASENA` varchar(255) NOT NULL,
  `ID_ROL` int NOT NULL,
  `FECHA_ULTIMA_CONEXION` datetime DEFAULT NULL,
  `FECHA_VENCIMIENTO` date DEFAULT NULL,
  `CORREO_ELECTRONICO` varchar(100) DEFAULT NULL,
  `INTENTOS_FALLIDOS` int DEFAULT '0',
  `GOOGLE_ID` varchar(100) DEFAULT NULL,
  `TWO_FACTOR_ENABLED` tinyint(1) DEFAULT '0',
  `TWO_FACTOR_SECRET` varchar(100) DEFAULT NULL,
  `SECRET_2FA` varchar(255) DEFAULT NULL,
  `ACTIVO_2FA` tinyint(1) NOT NULL DEFAULT '0',
  `FECHA_ACTIVACION_2FA` datetime DEFAULT NULL,
  `ULTIMO_CODIGO_2FA` varchar(10) DEFAULT NULL,
  `INTENTOS_2FA_FALLIDOS` int DEFAULT '0',
  `BLOQUEO_2FA_HASTA` datetime DEFAULT NULL,
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  `CODIGO_RECUPERACION` int DEFAULT NULL,
  `EXPIRA_CODIGO` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_USUARIO`),
  UNIQUE KEY `USUARIO` (`USUARIO`),
  UNIQUE KEY `GOOGLE_ID` (`GOOGLE_ID`),
  KEY `ID_ROL` (`ID_ROL`),
  KEY `idx_usuario_estado` (`ESTADO`),
  KEY `idx_usuario_fecha_vencimiento` (`FECHA_VENCIMIENTO`),
  KEY `idx_usuario_2fa` (`ACTIVO_2FA`),
  CONSTRAINT `tbl_ms_usuario_ibfk_1` FOREIGN KEY (`ID_ROL`) REFERENCES `tbl_ms_roles` (`ID_ROL`),
  CONSTRAINT `tbl_ms_usuario_chk_1` CHECK ((`ESTADO` in (_utf8mb4'ACTIVO',_utf8mb4'INACTIVO',_utf8mb4'BLOQUEADO',_utf8mb4'NUEVO')))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_ms_usuario`
--

LOCK TABLES `tbl_ms_usuario` WRITE;
/*!40000 ALTER TABLE `tbl_ms_usuario` DISABLE KEYS */;
INSERT INTO `tbl_ms_usuario` VALUES (1,'ADMIN','ADMINISTRADOR DEL SISTEMA','ACTIVO','Admin123!',1,NULL,'2025-12-26','admin@rocamaya.com',0,NULL,0,NULL,NULL,1,NULL,NULL,0,NULL,'2025-11-26 23:37:20','SISTEMA','2025-11-26 23:37:20',NULL,NULL,NULL),(2,'DR.Denis','DENIS SANDOVAL','ACTIVO','Temp123!',2,NULL,'2025-12-26','dr.garcia@rocamaya.com',0,NULL,0,NULL,NULL,0,NULL,NULL,0,NULL,'2025-11-26 23:37:20','ADMIN','2025-11-28 14:47:16',NULL,NULL,NULL),(3,'ENF.ROSA','LIC. ROSA MARÍA HERNÁNDEZ','ACTIVO','Temp123!',3,NULL,'2025-12-26','enf.rosa@rocamaya.com',0,NULL,0,NULL,NULL,0,NULL,NULL,0,NULL,'2025-11-26 23:37:20','ADMIN','2025-11-26 23:37:20',NULL,NULL,NULL),(4,'RECEP.ANA','ANA LUCÍA GÓMEZ','ACTIVO','Temp123!',4,NULL,'2025-12-26','recepcion@rocamaya.com',0,NULL,0,NULL,NULL,0,NULL,NULL,0,NULL,'2025-11-26 23:37:20','ADMIN','2025-11-26 23:37:20',NULL,NULL,NULL),(5,'administrador','ADMINISTRADOR DEL SISTEMA','ACTIVO','$2b$10$2lGf2VHi/xXxoXtmFE0ACeU17ztJaApQoH25NSIehKC5BQpRaL6li',1,NULL,NULL,'eduar64.weebly.com@gmail.com',0,NULL,0,NULL,NULL,0,NULL,NULL,0,NULL,'2025-11-26 23:39:16',NULL,'2025-11-28 20:02:04',NULL,NULL,NULL),(6,'DR Victor Martinez','Victor Martinez Alvarado','ACTIVO','$2b$10$WCGbZMe/FEBzJ6GE1w684exdbuz8xk5cc8DVhadlzGHjlJ9kteobq',2,NULL,NULL,'dr.victor.martinez@gmail.com',0,NULL,0,NULL,NULL,0,NULL,NULL,0,NULL,'2025-11-28 15:08:14',NULL,'2025-11-28 15:17:20',NULL,NULL,NULL),(7,'DrFrancisco Amaya','Francisco Amaya','ACTIVO','$2b$10$U0yWp6hUfkAJB8qdfocgeepVsR1I01fUVWV4OLVl96Yg4ecpTEnjq',2,NULL,NULL,'dr.francisco.amaya@gmail.com',0,NULL,0,NULL,NULL,0,NULL,NULL,0,NULL,'2025-11-28 15:09:46',NULL,'2025-11-28 15:17:11',NULL,NULL,NULL),(8,'DRMoisésHenriquez ','Moisés Henriquez ','ACTIVO','$2b$10$5iZedLjMtuUBzBO9CnI5v.eR1xnR7nz7jS3egD2y/8yY.OGVd8qYi',2,NULL,NULL,'dr.moises.henriquez@gmail.com',0,NULL,0,NULL,NULL,0,NULL,NULL,0,NULL,'2025-11-28 15:12:01',NULL,'2025-11-28 15:17:05',NULL,NULL,NULL),(9,'DRACelestePinto','Celeste Pinto','ACTIVO','$2b$10$HXrDf8doUKRSigk1Il6z.ezYa327SiUwnLvgZgVivqJQw5vxd5KM6',2,NULL,NULL,'dra.celeste.pinto@gmail.com',0,NULL,0,NULL,NULL,0,NULL,NULL,0,NULL,'2025-11-28 15:13:54',NULL,'2025-11-28 15:16:58',NULL,NULL,NULL);
/*!40000 ALTER TABLE `tbl_ms_usuario` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_USUARIOS_INSERT` AFTER INSERT ON `tbl_ms_usuario` FOR EACH ROW BEGIN
    DECLARE v_id_usuario_creador INT;
    
    -- Buscar ID del usuario creador
    SELECT COALESCE(ID_USUARIO, 1) INTO v_id_usuario_creador 
    FROM TBL_MS_USUARIO 
    WHERE USUARIO = COALESCE(NEW.USUARIO_CREACION, 'SISTEMA')
    LIMIT 1;
    
    CALL SP_REGISTRAR_BITACORA(
        v_id_usuario_creador,
        'CREACION_USUARIO',
        CONCAT('Nuevo usuario creado: ', NEW.USUARIO, ' - ', NEW.NOMBRE_USUARIO),
        'USUARIOS',
        NEW.ID_USUARIO,
        'TBL_MS_USUARIO',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_2FA_UPDATE` AFTER UPDATE ON `tbl_ms_usuario` FOR EACH ROW BEGIN
    IF OLD.ACTIVO_2FA != NEW.ACTIVO_2FA THEN
        IF NEW.ACTIVO_2FA = 1 THEN
            CALL SP_REGISTRAR_BITACORA(
                NEW.ID_USUARIO,
                'ACTIVACION_2FA',
                'Usuario activó autenticación de dos factores',
                'SEGURIDAD',
                NEW.ID_USUARIO,
                'TBL_MS_USUARIO',
                NULL, NULL, 'EXITO', NULL,
                'TRIGGER'
            );
        ELSE
            CALL SP_REGISTRAR_BITACORA(
                NEW.ID_USUARIO,
                'DESACTIVACION_2FA',
                'Usuario desactivó autenticación de dos factores',
                'SEGURIDAD',
                NEW.ID_USUARIO,
                'TBL_MS_USUARIO',
                NULL, NULL, 'EXITO', NULL,
                'TRIGGER'
            );
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_USUARIOS_UPDATE` AFTER UPDATE ON `tbl_ms_usuario` FOR EACH ROW BEGIN
    DECLARE v_cambios TEXT DEFAULT '';
    DECLARE v_id_usuario_modificador INT;
    
    -- Buscar ID del usuario modificador
    SELECT COALESCE(ID_USUARIO, 1) INTO v_id_usuario_modificador 
    FROM TBL_MS_USUARIO 
    WHERE USUARIO = COALESCE(NEW.USUARIO_MODIFICACION, 'SISTEMA')
    LIMIT 1;
    
    -- Detectar cambios específicos
    IF OLD.ESTADO != NEW.ESTADO THEN
        SET v_cambios = CONCAT(v_cambios, 'Estado: ', OLD.ESTADO, ' → ', NEW.ESTADO, '; ');
    END IF;
    
    IF OLD.INTENTOS_FALLIDOS != NEW.INTENTOS_FALLIDOS THEN
        SET v_cambios = CONCAT(v_cambios, 'Intentos: ', OLD.INTENTOS_FALLIDOS, ' → ', NEW.INTENTOS_FALLIDOS, '; ');
    END IF;
    
    IF OLD.ACTIVO_2FA != NEW.ACTIVO_2FA THEN
        SET v_cambios = CONCAT(v_cambios, '2FA: ', OLD.ACTIVO_2FA, ' → ', NEW.ACTIVO_2FA, '; ');
    END IF;
    
    IF v_cambios = '' THEN
        SET v_cambios = 'Actualización general del usuario';
    END IF;
    
    CALL SP_REGISTRAR_BITACORA(
        v_id_usuario_modificador,
        'ACTUALIZACION_USUARIO',
        CONCAT('Usuario actualizado: ', NEW.USUARIO, ' - Cambios: ', v_cambios),
        'USUARIOS',
        NEW.ID_USUARIO,
        'TBL_MS_USUARIO',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_objetos`
--

DROP TABLE IF EXISTS `tbl_objetos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_objetos` (
  `ID_OBJETO` int NOT NULL AUTO_INCREMENT,
  `OBJETO` varchar(100) NOT NULL,
  `DESCRIPCION` varchar(255) DEFAULT NULL,
  `TIPO_OBJETO` varchar(50) DEFAULT NULL,
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_OBJETO`),
  UNIQUE KEY `OBJETO` (`OBJETO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_objetos`
--

LOCK TABLES `tbl_objetos` WRITE;
/*!40000 ALTER TABLE `tbl_objetos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_objetos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_paciente`
--

DROP TABLE IF EXISTS `tbl_paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_paciente` (
  `ID_PACIENTE` int NOT NULL AUTO_INCREMENT,
  `NOMBRES` varchar(100) NOT NULL,
  `APELLIDOS` varchar(100) NOT NULL,
  `FECHA_NACIMIENTO` date DEFAULT NULL,
  `GENERO` enum('MASCULINO','FEMENINO','OTRO','PREFIERO_NO_DECIR') DEFAULT NULL,
  `DIRECCION` varchar(255) DEFAULT NULL,
  `TELEFONO` varchar(20) DEFAULT NULL,
  `CORREO_ELECTRONICO` varchar(100) DEFAULT NULL,
  `TIPO_DOCUMENTO_IDENTIDAD` enum('DNI','PASAPORTE','LICENCIA','OTRO') DEFAULT 'DNI',
  `NUMERO_DOCUMENTO_IDENTIDAD` varchar(50) DEFAULT NULL,
  `RTN_PACIENTE` varchar(50) DEFAULT NULL,
  `ESTADO_CIVIL` enum('SOLTERO','CASADO','DIVORCIADO','VIUDO','UNION_LIBRE') DEFAULT NULL,
  `OCUPACION` varchar(100) DEFAULT NULL,
  `NOMBRE_CONTACTO_EMERGENCIA` varchar(200) DEFAULT NULL,
  `TELEFONO_CONTACTO_EMERGENCIA` varchar(20) DEFAULT NULL,
  `PARENTESCO_CONTACTO_EMERGENCIA` varchar(50) DEFAULT NULL,
  `ESTADO` enum('ACTIVO','INACTIVO','BLOQUEADO') DEFAULT 'ACTIVO',
  `FECHA_REGISTRO` datetime DEFAULT CURRENT_TIMESTAMP,
  `ID_USUARIO_REGISTRO` int DEFAULT NULL,
  `FECHA_ACTUALIZACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_PACIENTE`),
  UNIQUE KEY `NUMERO_DOCUMENTO_IDENTIDAD` (`NUMERO_DOCUMENTO_IDENTIDAD`),
  KEY `ID_USUARIO_REGISTRO` (`ID_USUARIO_REGISTRO`),
  KEY `idx_paciente_documento` (`NUMERO_DOCUMENTO_IDENTIDAD`),
  KEY `idx_paciente_nombres` (`NOMBRES`,`APELLIDOS`),
  KEY `idx_paciente_estado` (`ESTADO`),
  CONSTRAINT `tbl_paciente_ibfk_1` FOREIGN KEY (`ID_USUARIO_REGISTRO`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_paciente`
--

LOCK TABLES `tbl_paciente` WRITE;
/*!40000 ALTER TABLE `tbl_paciente` DISABLE KEYS */;
INSERT INTO `tbl_paciente` VALUES (1,'MARÍA ELENA','GARCÍA MARTÍNEZ','1985-03-15','FEMENINO','COLONIA PALMIRA, CALLE PRINCIPAL #123, TEGUCIGALPA','+504 2234-5678','maria.garcia@email.com','DNI','0801-1985-12345','0801198501234','CASADO','CONTADORA','CARLOS GARCÍA','+504 9876-5432','ESPOSO','ACTIVO','2025-11-26 23:37:20',1,'2025-11-26 23:37:20','ADMIN',NULL),(2,'JUAN CARLOS','LÓPEZ HERNÁNDEZ','1978-11-30','MASCULINO','RESIDENCIAL LOS PINOS, BLOQUE 5, CASA #45, SAN PEDRO SULA','+504 3345-6789','juan.lopez@email.com','DNI','0801-1978-98765','0801197809876','CASADO','INGENIERO INDUSTRIAL','ANA LÓPEZ','+504 8765-4321','ESPOSA','ACTIVO','2025-11-26 23:37:20',1,'2025-11-26 23:37:20','ADMIN',NULL);
/*!40000 ALTER TABLE `tbl_paciente` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_PACIENTES_INSERT` AFTER INSERT ON `tbl_paciente` FOR EACH ROW BEGIN
    CALL SP_REGISTRAR_BITACORA(
        COALESCE(NEW.ID_USUARIO_REGISTRO, 1),
        'CREACION_PACIENTE',
        CONCAT('Nuevo paciente creado: ', NEW.NOMBRES, ' ', NEW.APELLIDOS, ' (', NEW.NUMERO_DOCUMENTO_IDENTIDAD, ')'),
        'PACIENTES',
        NEW.ID_PACIENTE,
        'TBL_PACIENTE',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_PACIENTES_UPDATE` AFTER UPDATE ON `tbl_paciente` FOR EACH ROW BEGIN
    CALL SP_REGISTRAR_BITACORA(
        COALESCE(NEW.ID_USUARIO_REGISTRO, 1),
        'ACTUALIZACION_PACIENTE',
        CONCAT('Paciente actualizado: ', NEW.NOMBRES, ' ', NEW.APELLIDOS),
        'PACIENTES',
        NEW.ID_PACIENTE,
        'TBL_PACIENTE',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_permisos`
--

DROP TABLE IF EXISTS `tbl_permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_permisos` (
  `ID_PERMISO` int NOT NULL AUTO_INCREMENT,
  `ID_ROL` int NOT NULL,
  `ID_OBJETO` int NOT NULL,
  `PERMISO_INSERCION` tinyint(1) DEFAULT '0',
  `PERMISO_ELIMINACION` tinyint(1) DEFAULT '0',
  `PERMISO_ACTUALIZACION` tinyint(1) DEFAULT '0',
  `PERMISO_CONSULTA` tinyint(1) DEFAULT '0',
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `FECHA_MODIFICACION` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_PERMISO`),
  UNIQUE KEY `unique_rol_objeto` (`ID_ROL`,`ID_OBJETO`),
  KEY `ID_OBJETO` (`ID_OBJETO`),
  CONSTRAINT `tbl_permisos_ibfk_1` FOREIGN KEY (`ID_ROL`) REFERENCES `tbl_ms_roles` (`ID_ROL`),
  CONSTRAINT `tbl_permisos_ibfk_2` FOREIGN KEY (`ID_OBJETO`) REFERENCES `tbl_objetos` (`ID_OBJETO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_permisos`
--

LOCK TABLES `tbl_permisos` WRITE;
/*!40000 ALTER TABLE `tbl_permisos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_preclinica`
--

DROP TABLE IF EXISTS `tbl_preclinica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_preclinica` (
  `ID_PRECLINICA` int NOT NULL AUTO_INCREMENT,
  `ID_CITA` int NOT NULL,
  `ID_USUARIO_ENFERMERIA` int NOT NULL,
  `FECHA_REGISTRO` datetime DEFAULT CURRENT_TIMESTAMP,
  `TEMPERATURA` decimal(4,2) DEFAULT NULL,
  `PRESION_SISTOLICA` int DEFAULT NULL,
  `PRESION_DIASTOLICA` int DEFAULT NULL,
  `FRECUENCIA_CARDIACA` int DEFAULT NULL,
  `FRECUENCIA_RESPIRATORIA` int DEFAULT NULL,
  `SATURACION_OXIGENO` decimal(5,2) DEFAULT NULL,
  `PESO` decimal(5,2) DEFAULT NULL,
  `TALLA` decimal(5,2) DEFAULT NULL,
  `IMC` decimal(4,2) GENERATED ALWAYS AS ((`PESO` / (`TALLA` * `TALLA`))) STORED,
  `GLUCOSA` decimal(5,2) DEFAULT NULL,
  `PERIMETRO_ABDOMINAL` decimal(5,2) DEFAULT NULL,
  `OBSERVACIONES` text,
  `ESTADO_GENERAL` enum('BUENO','REGULAR','MALO') DEFAULT 'BUENO',
  `SIGNOS_VITALES_JSON` json DEFAULT NULL,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_PRECLINICA`),
  UNIQUE KEY `ID_CITA` (`ID_CITA`),
  KEY `ID_USUARIO_ENFERMERIA` (`ID_USUARIO_ENFERMERIA`),
  KEY `idx_preclinica_cita` (`ID_CITA`),
  CONSTRAINT `tbl_preclinica_ibfk_1` FOREIGN KEY (`ID_CITA`) REFERENCES `tbl_citas` (`ID_CITA`) ON DELETE CASCADE,
  CONSTRAINT `tbl_preclinica_ibfk_2` FOREIGN KEY (`ID_USUARIO_ENFERMERIA`) REFERENCES `tbl_ms_usuario` (`ID_USUARIO`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_preclinica`
--

LOCK TABLES `tbl_preclinica` WRITE;
/*!40000 ALTER TABLE `tbl_preclinica` DISABLE KEYS */;
INSERT INTO `tbl_preclinica` (`ID_PRECLINICA`, `ID_CITA`, `ID_USUARIO_ENFERMERIA`, `FECHA_REGISTRO`, `TEMPERATURA`, `PRESION_SISTOLICA`, `PRESION_DIASTOLICA`, `FRECUENCIA_CARDIACA`, `FRECUENCIA_RESPIRATORIA`, `SATURACION_OXIGENO`, `PESO`, `TALLA`, `GLUCOSA`, `PERIMETRO_ABDOMINAL`, `OBSERVACIONES`, `ESTADO_GENERAL`, `SIGNOS_VITALES_JSON`, `USUARIO_CREACION`, `USUARIO_MODIFICACION`) VALUES (1,1,3,'2025-11-26 23:37:20',36.80,140,90,78,16,98.50,65.50,1.62,95.00,85.00,'PACIENTE EN BUEN ESTADO GENERAL. REFIERE CEFALEA LEVE. PRESIÓN ARTERIAL ELEVADA.','REGULAR','{\"temperatura\": 36.8, \"presion_arterial\": \"140/90\", \"saturacion_oxigeno\": 98.5, \"frecuencia_cardiaca\": 78}','ENF.ROSA','ENF.ROSA'),(2,2,1,'2025-11-27 00:52:15',67.00,45,45,55,45,43.00,34.00,2.00,67.00,76.00,NULL,'BUENO','{\"peso\": \"34\", \"talla\": \"2\", \"temperatura\": \"67\"}','SISTEMA',NULL),(3,3,1,'2025-11-27 00:54:55',40.00,56,76,78,56,67.00,87.00,1.80,67.00,76.00,NULL,'BUENO','{\"peso\": \"87\", \"talla\": \"1.80\", \"temperatura\": \"40\"}','SISTEMA',NULL),(4,4,1,'2025-11-27 01:11:12',36.00,57,56,56,67,45.00,3.00,1.80,76.00,66.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(5,5,1,'2025-11-27 01:19:42',36.00,78,56,79,56,56.00,2.00,1.80,56.00,76.00,NULL,'BUENO','{\"peso\": \"2\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(6,6,1,'2025-11-27 01:22:51',36.00,78,56,45,56,56.00,3.00,1.80,45.00,67.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(7,7,1,'2025-11-27 01:25:27',36.00,76,45,45,45,67.00,2.00,1.80,56.00,56.00,NULL,'BUENO','{\"peso\": \"2\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(8,8,1,'2025-11-27 01:29:09',36.00,56,56,46,78,56.00,3.00,1.80,67.00,56.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(9,9,1,'2025-11-27 01:44:53',36.00,45,45,57,45,45.00,4.00,1.50,45.00,56.00,NULL,'BUENO','{\"peso\": \"4\", \"talla\": \"1.5\", \"temperatura\": \"36\"}','SISTEMA',NULL),(10,10,1,'2025-11-27 02:04:36',36.00,45,34,45,45,45.00,3.00,1.80,45.00,45.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(11,11,1,'2025-11-27 02:46:51',35.00,89,56,76,45,56.00,34.00,2.00,56.00,56.00,NULL,'BUENO','{\"peso\": \"34\", \"talla\": \"2\", \"temperatura\": \"35\"}','SISTEMA',NULL),(12,12,1,'2025-11-27 12:34:39',35.00,78,45,45,45,56.00,2.00,1.80,56.00,56.00,NULL,'BUENO','{\"peso\": \"2\", \"talla\": \"1.80\", \"temperatura\": \"35\"}','SISTEMA',NULL),(13,13,1,'2025-11-27 14:11:26',35.00,86,45,56,56,56.00,3.00,1.80,45.00,76.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"35\"}','SISTEMA',NULL),(14,14,1,'2025-11-27 14:17:50',35.00,67,56,56,56,67.00,3.00,1.80,56.00,56.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"35\"}','SISTEMA',NULL),(15,15,1,'2025-11-27 14:22:34',36.00,56,67,45,45,63.00,3.00,1.80,56.00,67.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(16,16,1,'2025-11-27 14:28:46',35.00,45,67,45,56,45.00,67.00,1.80,67.00,67.00,NULL,'BUENO','{\"peso\": \"67\", \"talla\": \"1.80\", \"temperatura\": \"35\"}','SISTEMA',NULL),(17,17,1,'2025-11-27 14:36:50',36.00,56,56,45,56,67.00,3.00,1.80,67.00,56.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(18,18,1,'2025-11-27 15:41:22',36.00,56,56,65,34,56.00,3.00,1.80,45.00,56.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"36\"}','SISTEMA',NULL),(19,19,1,'2025-11-27 16:06:22',35.00,45,56,45,34,45.00,3.00,1.80,45.00,67.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.80\", \"temperatura\": \"35\"}','SISTEMA',NULL),(20,20,1,'2025-11-27 16:24:48',40.00,45,45,66,56,45.00,2.00,1.80,56.00,56.00,NULL,'BUENO','{\"peso\": \"2\", \"talla\": \"1.80\", \"temperatura\": \"40\"}','SISTEMA',NULL),(21,21,1,'2025-11-27 16:26:39',36.00,56,45,56,56,45.00,2.00,2.00,56.00,56.00,NULL,'BUENO','{\"peso\": \"2\", \"talla\": \"2\", \"temperatura\": \"36\"}','SISTEMA',NULL),(22,22,1,'2025-11-27 17:20:00',36.00,45,45,56,56,56.00,3.00,1.60,56.00,56.00,NULL,'BUENO','{\"peso\": \"3\", \"talla\": \"1.6\", \"temperatura\": \"36\"}','SISTEMA',NULL),(23,23,1,'2025-11-27 19:31:50',35.00,56,56,45,45,45.00,2.00,1.60,56.00,56.00,NULL,'BUENO','{\"peso\": \"2\", \"talla\": \"1.60\", \"temperatura\": \"35\"}','SISTEMA',NULL),(24,24,1,'2025-11-28 14:32:26',35.00,56,78,56,54,56.00,3.00,1.50,45.00,56.00,NULL,'REGULAR','{\"peso\": \"3\", \"talla\": \"1.50\", \"temperatura\": \"35\"}','SISTEMA',NULL);
/*!40000 ALTER TABLE `tbl_preclinica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_prescripcion`
--

DROP TABLE IF EXISTS `tbl_prescripcion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_prescripcion` (
  `ID_PRESCRIPCION` int NOT NULL AUTO_INCREMENT,
  `ID_CONSULTA` int NOT NULL,
  `ID_MEDICAMENTO` int NOT NULL,
  `FECHA_PRESCRIPCION` datetime DEFAULT CURRENT_TIMESTAMP,
  `DOSIS` varchar(50) NOT NULL,
  `FRECUENCIA` varchar(50) DEFAULT NULL,
  `DURACION` varchar(50) DEFAULT NULL,
  `CANTIDAD_TOTAL` int DEFAULT NULL,
  `INSTRUCCIONES_ADICIONALES` text,
  `ESTADO` enum('ACTIVA','COMPLETADA','SUSPENDIDA') DEFAULT 'ACTIVA',
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_PRESCRIPCION`),
  KEY `ID_MEDICAMENTO` (`ID_MEDICAMENTO`),
  KEY `idx_prescripcion_consulta` (`ID_CONSULTA`),
  CONSTRAINT `tbl_prescripcion_ibfk_1` FOREIGN KEY (`ID_CONSULTA`) REFERENCES `tbl_consulta_medica` (`ID_CONSULTA`) ON DELETE CASCADE,
  CONSTRAINT `tbl_prescripcion_ibfk_2` FOREIGN KEY (`ID_MEDICAMENTO`) REFERENCES `tbl_inventario_medicamentos` (`ID_MEDICAMENTO`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_prescripcion`
--

LOCK TABLES `tbl_prescripcion` WRITE;
/*!40000 ALTER TABLE `tbl_prescripcion` DISABLE KEYS */;
INSERT INTO `tbl_prescripcion` VALUES (1,1,1,'2025-11-26 23:37:20','100MG','1 VEZ AL DÍA','30 DÍAS',30,'TOMAR EN LA MAÑANA CON EL DESAYUNO','ACTIVA','DR.GARCIA','DR.GARCIA'),(2,1,2,'2025-11-26 23:37:20','12.5MG','1 VEZ AL DÍA','30 DÍAS',30,'TOMAR EN LA MAÑANA','ACTIVA','DR.GARCIA','DR.GARCIA');
/*!40000 ALTER TABLE `tbl_prescripcion` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `TR_AUDITORIA_PRESCRIPCIONES_INSERT` AFTER INSERT ON `tbl_prescripcion` FOR EACH ROW BEGIN
    DECLARE v_medicamento_nombre VARCHAR(255);
    DECLARE v_id_doctor INT;
    
    -- Obtener nombre del medicamento
    SELECT COALESCE(NOMBRE_MEDICAMENTO, 'MEDICAMENTO DESCONOCIDO') INTO v_medicamento_nombre 
    FROM TBL_INVENTARIO_MEDICAMENTO 
    WHERE ID_MEDICAMENTO = NEW.ID_MEDICAMENTO;
    
    -- Obtener ID del doctor
    SELECT COALESCE(ID_DOCTOR, 1) INTO v_id_doctor 
    FROM TBL_CONSULTA_MEDICA 
    WHERE ID_CONSULTA = NEW.ID_CONSULTA;
    
    CALL SP_REGISTRAR_BITACORA(
        v_id_doctor,
        'PRESCRIPCION_MEDICA',
        CONCAT('Prescripción de ', v_medicamento_nombre, ' - Dosis: ', NEW.DOSIS),
        'FARMACIA',
        NEW.ID_PRESCRIPCION,
        'TBL_PRESCRIPCION',
        NULL, NULL, 'EXITO', NULL,
        'TRIGGER'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_recibo`
--

DROP TABLE IF EXISTS `tbl_recibo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_recibo` (
  `ID_RECIBO` int NOT NULL AUTO_INCREMENT,
  `ID_PACIENTE` int NOT NULL,
  `ID_CITA` int DEFAULT NULL COMMENT 'Cita que generó este recibo',
  `NUMERO_RECIBO` varchar(50) NOT NULL,
  `CAI` varchar(100) DEFAULT NULL,
  `FECHA_EMISION` date NOT NULL,
  `FECHA_VENCIMIENTO` date DEFAULT NULL,
  `FECHA_PAGO` datetime DEFAULT NULL,
  `SUBTOTAL` decimal(10,2) NOT NULL,
  `ISV` decimal(10,2) NOT NULL,
  `DESCUENTO` decimal(10,2) NOT NULL,
  `MONTO_TOTAL` decimal(10,2) NOT NULL,
  `SALDO_PENDIENTE` decimal(10,2) NOT NULL,
  `TIPO_PAGO` varchar(50) NOT NULL COMMENT 'Efectivo, Tarjeta, Transferencia, etc.',
  `TERMINOS_PAGO` varchar(50) DEFAULT NULL,
  `DESCRIPCION` text,
  `ESTADO_RECIBO` varchar(20) NOT NULL COMMENT 'PENDIENTE, PAGADO, CANCELADO',
  `FECHA_CREACION` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_RECIBO`),
  UNIQUE KEY `NUMERO_RECIBO` (`NUMERO_RECIBO`),
  KEY `ID_PACIENTE` (`ID_PACIENTE`),
  KEY `ID_CITA` (`ID_CITA`),
  CONSTRAINT `tbl_recibo_ibfk_1` FOREIGN KEY (`ID_PACIENTE`) REFERENCES `tbl_paciente` (`ID_PACIENTE`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `tbl_recibo_ibfk_2` FOREIGN KEY (`ID_CITA`) REFERENCES `tbl_citas` (`ID_CITA`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_recibo`
--

LOCK TABLES `tbl_recibo` WRITE;
/*!40000 ALTER TABLE `tbl_recibo` DISABLE KEYS */;
INSERT INTO `tbl_recibo` VALUES (2,2,8,'1',NULL,'2025-11-27',NULL,NULL,300.00,45.00,0.00,345.00,345.00,'EFECTIVO',NULL,NULL,'PENDIENTE','2025-11-27 07:29:30',NULL),(3,1,9,'11',NULL,'2025-11-27',NULL,'2025-11-27 01:47:51',300.00,45.00,0.00,345.00,0.00,'EFECTIVO',NULL,NULL,'PAGADA','2025-11-27 07:46:00',NULL),(4,1,10,'111',NULL,'2025-11-27',NULL,'2025-11-27 02:12:21',300.00,45.00,0.00,345.00,0.00,'EFECTIVO',NULL,NULL,'PAGADA','2025-11-27 08:05:59',NULL),(5,1,16,'1111',NULL,'2025-11-27',NULL,'2025-11-27 15:15:02',300.00,45.00,0.00,345.00,0.00,'EFECTIVO',NULL,NULL,'PAGADA','2025-11-27 20:29:13',NULL),(6,2,17,'11111',NULL,'2025-11-27',NULL,NULL,300.00,45.00,0.00,345.00,345.00,'EFECTIVO',NULL,NULL,'ANULADA','2025-11-27 20:37:25',NULL),(7,2,18,'111111',NULL,'2025-11-27',NULL,NULL,300.00,45.00,0.00,345.00,345.00,'EFECTIVO',NULL,NULL,'PENDIENTE','2025-11-27 21:41:59',NULL),(8,1,21,'1111111',NULL,'2025-11-27',NULL,NULL,300.00,45.00,0.00,345.00,345.00,'EFECTIVO',NULL,NULL,'ANULADA','2025-11-27 22:27:10',NULL),(9,2,22,'11111111',NULL,'2025-11-27',NULL,'2025-11-27 17:22:39',300.00,45.00,0.00,345.00,0.00,'EFECTIVO',NULL,NULL,'PAGADA','2025-11-27 23:20:35',NULL),(10,1,23,'111111111',NULL,'2025-11-27',NULL,NULL,300.00,45.00,0.00,345.00,345.00,'EFECTIVO',NULL,NULL,'PENDIENTE','2025-11-28 01:32:15',NULL),(11,1,24,'1111111111',NULL,'2025-11-28',NULL,NULL,150.00,22.50,0.00,172.50,172.50,'EFECTIVO',NULL,NULL,'PENDIENTE','2025-11-28 20:32:52',NULL);
/*!40000 ALTER TABLE `tbl_recibo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_recibo_detalle`
--

DROP TABLE IF EXISTS `tbl_recibo_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_recibo_detalle` (
  `ID_DETALLE` int NOT NULL AUTO_INCREMENT,
  `ID_RECIBO` int NOT NULL,
  `ID_SERVICIO` int NOT NULL,
  `CANTIDAD` decimal(10,2) NOT NULL,
  `PRECIO_UNITARIO` decimal(10,2) NOT NULL,
  `TOTAL` decimal(10,2) NOT NULL,
  `FECHA_CREACION` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_DETALLE`),
  KEY `ID_RECIBO` (`ID_RECIBO`),
  KEY `ID_SERVICIO` (`ID_SERVICIO`),
  CONSTRAINT `tbl_recibo_detalle_ibfk_1` FOREIGN KEY (`ID_RECIBO`) REFERENCES `tbl_recibo` (`ID_RECIBO`),
  CONSTRAINT `tbl_recibo_detalle_ibfk_2` FOREIGN KEY (`ID_SERVICIO`) REFERENCES `tbl_servicios_medicos` (`ID_SERVICIO`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_recibo_detalle`
--

LOCK TABLES `tbl_recibo_detalle` WRITE;
/*!40000 ALTER TABLE `tbl_recibo_detalle` DISABLE KEYS */;
INSERT INTO `tbl_recibo_detalle` VALUES (1,2,1,1.00,300.00,300.00,'2025-11-27 07:29:30',NULL),(2,3,1,1.00,300.00,300.00,'2025-11-27 07:46:00',NULL),(3,4,1,1.00,300.00,300.00,'2025-11-27 08:05:59',NULL),(4,5,1,1.00,300.00,300.00,'2025-11-27 20:29:13',NULL),(5,6,1,1.00,300.00,300.00,'2025-11-27 20:37:25',NULL),(6,7,1,1.00,300.00,300.00,'2025-11-27 21:41:59',NULL),(7,8,1,1.00,300.00,300.00,'2025-11-27 22:27:10',NULL),(8,9,1,1.00,300.00,300.00,'2025-11-27 23:20:35',NULL),(9,10,1,1.00,300.00,300.00,'2025-11-28 01:32:15',NULL),(10,11,1,1.00,150.00,150.00,'2025-11-28 20:32:52',NULL);
/*!40000 ALTER TABLE `tbl_recibo_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_servicios_medicos`
--

DROP TABLE IF EXISTS `tbl_servicios_medicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbl_servicios_medicos` (
  `ID_SERVICIO` int NOT NULL AUTO_INCREMENT,
  `NOMBRE_SERVICIO` varchar(200) NOT NULL,
  `DESCRIPCION` text,
  `PRECIO_UNITARIO` decimal(10,2) NOT NULL,
  `CODIGO_CIEO_10` varchar(20) DEFAULT NULL,
  `CODIGO_CUPS` varchar(20) DEFAULT NULL,
  `TIPO_SERVICIO` enum('CONSULTA','EXAMEN','PROCEDIMIENTO','TERAPIA','HOSPITALIZACION') DEFAULT 'CONSULTA',
  `CATEGORIA` varchar(100) DEFAULT NULL,
  `ESTADO` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `FECHA_CREACION` datetime DEFAULT CURRENT_TIMESTAMP,
  `USUARIO_CREACION` varchar(50) DEFAULT NULL,
  `USUARIO_MODIFICACION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_SERVICIO`),
  KEY `idx_servicio_tipo` (`TIPO_SERVICIO`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_servicios_medicos`
--

LOCK TABLES `tbl_servicios_medicos` WRITE;
/*!40000 ALTER TABLE `tbl_servicios_medicos` DISABLE KEYS */;
INSERT INTO `tbl_servicios_medicos` VALUES (1,'CONSULTA GENERAL','CONSULTA MÉDICA GENERAL',500.00,NULL,NULL,'CONSULTA',NULL,'ACTIVO','2025-11-26 23:37:20','SISTEMA',NULL),(2,'CONSULTA ESPECIALIDAD','CONSULTA CON ESPECIALISTA',800.00,NULL,NULL,'CONSULTA',NULL,'ACTIVO','2025-11-26 23:37:20','SISTEMA',NULL),(3,'EXAMEN DE SANGRE','HEMOGRAMA COMPLETO',300.00,NULL,NULL,'EXAMEN',NULL,'ACTIVO','2025-11-26 23:37:20','SISTEMA',NULL),(4,'RAYOS X','RADIOGRAFÍA SIMPLE',450.00,NULL,NULL,'EXAMEN',NULL,'ACTIVO','2025-11-26 23:37:20','SISTEMA',NULL),(5,'ELECTROCARDIOGRAMA','ECG ESTÁNDAR',600.00,NULL,NULL,'EXAMEN',NULL,'ACTIVO','2025-11-26 23:37:20','SISTEMA',NULL);
/*!40000 ALTER TABLE `tbl_servicios_medicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_bitacora_completa`
--

DROP TABLE IF EXISTS `vw_bitacora_completa`;
/*!50001 DROP VIEW IF EXISTS `vw_bitacora_completa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_bitacora_completa` AS SELECT 
 1 AS `ID_BITACORA`,
 1 AS `FECHA_HORA`,
 1 AS `USUARIO`,
 1 AS `NOMBRE_USUARIO`,
 1 AS `ROL`,
 1 AS `ACCION`,
 1 AS `DESCRIPCION`,
 1 AS `MODULO`,
 1 AS `TABLA_AFECTADA`,
 1 AS `ID_REGISTRO_AFECTADO`,
 1 AS `IP_CLIENTE`,
 1 AS `ESTADO_OPERACION`,
 1 AS `DETALLE_ERROR`,
 1 AS `USER_AGENT`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_citas_completas`
--

DROP TABLE IF EXISTS `vw_citas_completas`;
/*!50001 DROP VIEW IF EXISTS `vw_citas_completas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_citas_completas` AS SELECT 
 1 AS `ID_CITA`,
 1 AS `FECHA_CITA`,
 1 AS `FECHA_FIN_ESTIMADA`,
 1 AS `ESTADO_CITA`,
 1 AS `PRIORIDAD`,
 1 AS `TIPO_CITA`,
 1 AS `ID_PACIENTE`,
 1 AS `NOMBRE_PACIENTE`,
 1 AS `TELEFONO`,
 1 AS `CORREO_ELECTRONICO`,
 1 AS `ID_DOCTOR`,
 1 AS `NOMBRE_DOCTOR`,
 1 AS `NOMBRE_ESPECIALIDAD`,
 1 AS `MOTIVO_CONSULTA`,
 1 AS `OBSERVACIONES`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_estadisticas_bitacora`
--

DROP TABLE IF EXISTS `vw_estadisticas_bitacora`;
/*!50001 DROP VIEW IF EXISTS `vw_estadisticas_bitacora`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_estadisticas_bitacora` AS SELECT 
 1 AS `FECHA`,
 1 AS `MODULO`,
 1 AS `ESTADO_OPERACION`,
 1 AS `TOTAL_OPERACIONES`,
 1 AS `USUARIOS_ACTIVOS`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_estado_seguridad_2fa`
--

DROP TABLE IF EXISTS `vw_estado_seguridad_2fa`;
/*!50001 DROP VIEW IF EXISTS `vw_estado_seguridad_2fa`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_estado_seguridad_2fa` AS SELECT 
 1 AS `ID_USUARIO`,
 1 AS `USUARIO`,
 1 AS `NOMBRE_USUARIO`,
 1 AS `ACTIVO_2FA`,
 1 AS `FECHA_ACTIVACION_2FA`,
 1 AS `INTENTOS_2FA_FALLIDOS`,
 1 AS `BLOQUEO_2FA_HASTA`,
 1 AS `ROL`,
 1 AS `ESTADO_SEGURIDAD`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_usuarios_completos`
--

DROP TABLE IF EXISTS `vw_usuarios_completos`;
/*!50001 DROP VIEW IF EXISTS `vw_usuarios_completos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_usuarios_completos` AS SELECT 
 1 AS `ID_USUARIO`,
 1 AS `USUARIO`,
 1 AS `NOMBRE_USUARIO`,
 1 AS `ESTADO`,
 1 AS `CORREO_ELECTRONICO`,
 1 AS `FECHA_ULTIMA_CONEXION`,
 1 AS `FECHA_VENCIMIENTO`,
 1 AS `INTENTOS_FALLIDOS`,
 1 AS `ACTIVO_2FA`,
 1 AS `FECHA_ACTIVACION_2FA`,
 1 AS `INTENTOS_2FA_FALLIDOS`,
 1 AS `BLOQUEO_2FA_HASTA`,
 1 AS `ROL`,
 1 AS `DESCRIPCION_ROL`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'roca_maya'
--

--
-- Dumping routines for database 'roca_maya'
--
/*!50003 DROP PROCEDURE IF EXISTS `SP_ACTIVAR_2FA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ACTIVAR_2FA`(
    IN p_ID_USUARIO INT,
    IN p_SECRET_2FA VARCHAR(255),
    IN p_USUARIO_ACTUALIZACION VARCHAR(50)
)
BEGIN
    UPDATE TBL_MS_USUARIO 
    SET SECRET_2FA = p_SECRET_2FA,
        ACTIVO_2FA = 1,
        FECHA_ACTIVACION_2FA = CURRENT_TIMESTAMP,
        FECHA_MODIFICACION = CURRENT_TIMESTAMP,
        USUARIO_MODIFICACION = p_USUARIO_ACTUALIZACION
    WHERE ID_USUARIO = p_ID_USUARIO;
    
    -- Registrar en bitácora
    CALL SP_REGISTRAR_BITACORA(
        p_ID_USUARIO,
        'ACTIVACION_2FA',
        'Usuario activó autenticación de dos factores',
        'SEGURIDAD',
        p_ID_USUARIO,
        'TBL_MS_USUARIO',
        NULL, NULL, 'EXITO', NULL,
        p_USUARIO_ACTUALIZACION
    );
    
    SELECT 'EXITO' AS RESULTADO, '2FA ACTIVADO CORRECTAMENTE' AS MENSAJE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_CONSULTAR_BITACORA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CONSULTAR_BITACORA`(
    IN p_FECHA_INICIO DATETIME,
    IN p_FECHA_FIN DATETIME,
    IN p_ID_USUARIO INT,
    IN p_MODULO VARCHAR(50),
    IN p_ACCION VARCHAR(100)
)
BEGIN
    SELECT 
        b.ID_BITACORA,
        b.FECHA_HORA,
        COALESCE(u.USUARIO, 'SISTEMA') AS USUARIO,
        COALESCE(u.NOMBRE_USUARIO, 'SISTEMA') AS NOMBRE_USUARIO,
        b.ACCION,
        b.DESCRIPCION,
        b.MODULO,
        b.TABLA_AFECTADA,
        b.ID_REGISTRO_AFECTADO,
        b.IP_CLIENTE,
        b.ESTADO_OPERACION,
        b.DETALLE_ERROR
    FROM TBL_MS_BITACORA b
    LEFT JOIN TBL_MS_USUARIO u ON b.ID_USUARIO = u.ID_USUARIO
    WHERE 
        (p_FECHA_INICIO IS NULL OR b.FECHA_HORA >= p_FECHA_INICIO) AND
        (p_FECHA_FIN IS NULL OR b.FECHA_HORA <= p_FECHA_FIN) AND
        (p_ID_USUARIO IS NULL OR b.ID_USUARIO = p_ID_USUARIO) AND
        (p_MODULO IS NULL OR b.MODULO = p_MODULO) AND
        (p_ACCION IS NULL OR b.ACCION = p_ACCION)
    ORDER BY b.FECHA_HORA DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_DESACTIVAR_2FA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DESACTIVAR_2FA`(
    IN p_ID_USUARIO INT,
    IN p_USUARIO_ACTUALIZACION VARCHAR(50)
)
BEGIN
    UPDATE TBL_MS_USUARIO 
    SET ACTIVO_2FA = 0,
        SECRET_2FA = NULL,
        INTENTOS_2FA_FALLIDOS = 0,
        BLOQUEO_2FA_HASTA = NULL,
        FECHA_MODIFICACION = CURRENT_TIMESTAMP,
        USUARIO_MODIFICACION = p_USUARIO_ACTUALIZACION
    WHERE ID_USUARIO = p_ID_USUARIO;
    
    -- Registrar en bitácora
    CALL SP_REGISTRAR_BITACORA(
        p_ID_USUARIO,
        'DESACTIVACION_2FA',
        'Usuario desactivó autenticación de dos factores',
        'SEGURIDAD',
        p_ID_USUARIO,
        'TBL_MS_USUARIO',
        NULL, NULL, 'EXITO', NULL,
        p_USUARIO_ACTUALIZACION
    );
    
    SELECT 'EXITO' AS RESULTADO, '2FA DESACTIVADO CORRECTAMENTE' AS MENSAJE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_REGISTRAR_BITACORA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_REGISTRAR_BITACORA`(
    IN p_ID_USUARIO INT,
    IN p_ACCION VARCHAR(100),
    IN p_DESCRIPCION TEXT,
    IN p_MODULO VARCHAR(50),
    IN p_ID_REGISTRO_AFECTADO INT,
    IN p_TABLA_AFECTADA VARCHAR(50),
    IN p_IP_CLIENTE VARCHAR(45),
    IN p_USER_AGENT VARCHAR(500),
    IN p_ESTADO_OPERACION ENUM('EXITO','ERROR','ADVERTENCIA'),
    IN p_DETALLE_ERROR TEXT,
    IN p_USUARIO_CREACION VARCHAR(50)
)
BEGIN
    DECLARE v_usuario_valido INT DEFAULT NULL;
    
    -- Verificar si el ID_USUARIO existe
    IF p_ID_USUARIO IS NOT NULL THEN
        SELECT ID_USUARIO INTO v_usuario_valido 
        FROM TBL_MS_USUARIO 
        WHERE ID_USUARIO = p_ID_USUARIO;
    END IF;
    
    -- Si no existe el usuario, usar NULL
    IF v_usuario_valido IS NULL THEN
        SET p_ID_USUARIO = NULL;
    END IF;
    
    INSERT INTO TBL_MS_BITACORA (
        ID_USUARIO, ACCION, DESCRIPCION, MODULO, 
        ID_REGISTRO_AFECTADO, TABLA_AFECTADA, IP_CLIENTE, USER_AGENT,
        ESTADO_OPERACION, DETALLE_ERROR, USUARIO_CREACION
    ) VALUES (
        p_ID_USUARIO, p_ACCION, p_DESCRIPCION, p_MODULO,
        p_ID_REGISTRO_AFECTADO, p_TABLA_AFECTADA, p_IP_CLIENTE, p_USER_AGENT,
        p_ESTADO_OPERACION, p_DETALLE_ERROR, p_USUARIO_CREACION
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_VALIDAR_CODIGO_2FA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VALIDAR_CODIGO_2FA`(
    IN p_ID_USUARIO INT,
    IN p_CODIGO_2FA VARCHAR(10)
)
BEGIN
    DECLARE v_MAX_INTENTOS_2FA INT;
    DECLARE v_TIEMPO_BLOQUEO_MIN INT;
    DECLARE v_INTENTOS_2FA_FALLIDOS INT;
    DECLARE v_SECRET_2FA VARCHAR(255);
    DECLARE v_ACTIVO_2FA TINYINT(1);
    
    -- Obtener parámetros de 2FA
    SELECT VALOR INTO v_MAX_INTENTOS_2FA FROM TBL_MS_PARAMETROS WHERE PARAMETRO = '2FA_MAX_INTENTOS';
    IF v_MAX_INTENTOS_2FA IS NULL THEN SET v_MAX_INTENTOS_2FA = 3; END IF;
    
    SELECT VALOR INTO v_TIEMPO_BLOQUEO_MIN FROM TBL_MS_PARAMETROS WHERE PARAMETRO = '2FA_TIEMPO_BLOQUEO_MIN';
    IF v_TIEMPO_BLOQUEO_MIN IS NULL THEN SET v_TIEMPO_BLOQUEO_MIN = 30; END IF;
    
    -- Obtener datos del usuario
    SELECT INTENTOS_2FA_FALLIDOS, SECRET_2FA, ACTIVO_2FA
    INTO v_INTENTOS_2FA_FALLIDOS, v_SECRET_2FA, v_ACTIVO_2FA
    FROM TBL_MS_USUARIO 
    WHERE ID_USUARIO = p_ID_USUARIO;
    
    -- Verificar si 2FA está activo
    IF v_ACTIVO_2FA != 1 THEN
        SELECT 'ERROR' AS RESULTADO, '2FA NO ESTÁ ACTIVADO PARA ESTE USUARIO' AS MENSAJE;
    ELSEIF v_INTENTOS_2FA_FALLIDOS >= v_MAX_INTENTOS_2FA THEN
        -- Bloquear usuario por exceso de intentos 2FA
        UPDATE TBL_MS_USUARIO 
        SET BLOQUEO_2FA_HASTA = DATE_ADD(NOW(), INTERVAL v_TIEMPO_BLOQUEO_MIN MINUTE),
            FECHA_MODIFICACION = CURRENT_TIMESTAMP,
            USUARIO_MODIFICACION = 'SISTEMA'
        WHERE ID_USUARIO = p_ID_USUARIO;
        
        SELECT 'ERROR' AS RESULTADO, 
               CONCAT('CUENTA BLOQUEADA POR EXCESO DE INTENTOS 2FA. ESPERE ', v_TIEMPO_BLOQUEO_MIN, ' MINUTOS.') AS MENSAJE;
    ELSE
        -- Aquí se integraría la validación real del código TOTP
        -- Por ahora, simulamos una validación básica (en producción usarías una librería TOTP)
        IF LENGTH(p_CODIGO_2FA) = 6 AND p_CODIGO_2FA REGEXP '^[0-9]+$' THEN
            -- Código válido (simulación)
            UPDATE TBL_MS_USUARIO 
            SET INTENTOS_2FA_FALLIDOS = 0,
                BLOQUEO_2FA_HASTA = NULL,
                ULTIMO_CODIGO_2FA = p_CODIGO_2FA,
                FECHA_MODIFICACION = CURRENT_TIMESTAMP,
                USUARIO_MODIFICACION = 'SISTEMA'
            WHERE ID_USUARIO = p_ID_USUARIO;
            
            -- Registrar en bitácora
            CALL SP_REGISTRAR_BITACORA(
                p_ID_USUARIO,
                'VALIDACION_2FA_EXITOSA',
                'Validación de código 2FA exitosa',
                'AUTENTICACION',
                p_ID_USUARIO,
                'TBL_MS_USUARIO',
                NULL, NULL, 'EXITO', NULL,
                'SISTEMA'
            );
            
            SELECT 'EXITO' AS RESULTADO, 'CÓDIGO 2FA VÁLIDO' AS MENSAJE;
        ELSE
            -- Código inválido
            UPDATE TBL_MS_USUARIO 
            SET INTENTOS_2FA_FALLIDOS = v_INTENTOS_2FA_FALLIDOS + 1,
                FECHA_MODIFICACION = CURRENT_TIMESTAMP,
                USUARIO_MODIFICACION = 'SISTEMA'
            WHERE ID_USUARIO = p_ID_USUARIO;
            
            -- Registrar en bitácora
            CALL SP_REGISTRAR_BITACORA(
                p_ID_USUARIO,
                'VALIDACION_2FA_FALLIDA',
                'Intento fallido de validación de código 2FA',
                'AUTENTICACION',
                p_ID_USUARIO,
                'TBL_MS_USUARIO',
                NULL, NULL, 'ERROR', 'Código 2FA inválido',
                'SISTEMA'
            );
            
            SELECT 'ERROR' AS RESULTADO, 'CÓDIGO 2FA INVÁLIDO' AS MENSAJE;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_VALIDAR_LOGIN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VALIDAR_LOGIN`(
    IN p_USUARIO VARCHAR(50),
    IN p_CONTRASENA VARCHAR(255)
)
BEGIN
    DECLARE v_ID_USUARIO INT;
    DECLARE v_ESTADO VARCHAR(20);
    DECLARE v_INTENTOS_FALLIDOS INT;
    DECLARE v_MAX_INTENTOS INT;
    DECLARE v_CONTRASENA_DB VARCHAR(255);
    DECLARE v_FECHA_VENCIMIENTO DATE;
    DECLARE v_ES_PRIMER_INGRESO BOOLEAN;
    DECLARE v_ACTIVO_2FA TINYINT(1);
    DECLARE v_BLOQUEO_2FA_HASTA DATETIME;
    
    -- Obtener parámetro de intentos máximos
    SELECT VALOR INTO v_MAX_INTENTOS FROM TBL_MS_PARAMETROS WHERE PARAMETRO = 'ADMIN_INTENTOS_INVALIDOS';
    IF v_MAX_INTENTOS IS NULL THEN SET v_MAX_INTENTOS = 3; END IF;
    
    -- Buscar usuario (en mayúsculas según REQ001)
    SELECT ID_USUARIO, ESTADO, INTENTOS_FALLIDOS, CONTRASENA, FECHA_VENCIMIENTO, ACTIVO_2FA, BLOQUEO_2FA_HASTA
    INTO v_ID_USUARIO, v_ESTADO, v_INTENTOS_FALLIDOS, v_CONTRASENA_DB, v_FECHA_VENCIMIENTO, v_ACTIVO_2FA, v_BLOQUEO_2FA_HASTA
    FROM TBL_MS_USUARIO 
    WHERE USUARIO = UPPER(p_USUARIO);
    
    IF v_ID_USUARIO IS NULL THEN
        -- Usuario no existe
        SELECT 'ERROR' AS RESULTADO, 'USUARIO/CONTRASEÑA INVÁLIDOS' AS MENSAJE, NULL AS ID_USUARIO, FALSE AS REQUIERE_2FA;
    ELSE
        -- Verificar bloqueo por 2FA
        IF v_BLOQUEO_2FA_HASTA IS NOT NULL AND v_BLOQUEO_2FA_HASTA > NOW() THEN
            SELECT 'ERROR' AS RESULTADO, 
                   CONCAT('CUENTA BLOQUEADA POR INTENTOS FALLIDOS DE 2FA HASTA: ', 
                          DATE_FORMAT(v_BLOQUEO_2FA_HASTA, '%Y-%m-%d %H:%i:%s')) AS MENSAJE, 
                   NULL AS ID_USUARIO, FALSE AS REQUIERE_2FA;
        ELSE
            -- Verificar estado del usuario
            IF v_ESTADO = 'BLOQUEADO' THEN
                SELECT 'ERROR' AS RESULTADO, 'USUARIO BLOQUEADO. CONTACTE AL ADMINISTRADOR.' AS MENSAJE, NULL AS ID_USUARIO, FALSE AS REQUIERE_2FA;
            ELSEIF v_ESTADO = 'INACTIVO' THEN
                SELECT 'ERROR' AS RESULTADO, 'USUARIO INACTIVO. CONTACTE AL ADMINISTRADOR.' AS MENSAJE, NULL AS ID_USUARIO, FALSE AS REQUIERE_2FA;
            ELSEIF v_INTENTOS_FALLIDOS >= v_MAX_INTENTOS THEN
                -- Bloquear usuario por exceso de intentos
                UPDATE TBL_MS_USUARIO SET ESTADO = 'BLOQUEADO' WHERE ID_USUARIO = v_ID_USUARIO;
                SELECT 'ERROR' AS RESULTADO, 'USUARIO BLOQUEADO POR EXCESO DE INTENTOS FALLIDOS.' AS MENSAJE, NULL AS ID_USUARIO, FALSE AS REQUIERE_2FA;
            ELSEIF v_CONTRASENA_DB != p_CONTRASENA THEN
                -- Incrementar intentos fallidos
                UPDATE TBL_MS_USUARIO 
                SET INTENTOS_FALLIDOS = INTENTOS_FALLIDOS + 1,
                    FECHA_MODIFICACION = CURRENT_TIMESTAMP,
                    USUARIO_MODIFICACION = 'SISTEMA'
                WHERE ID_USUARIO = v_ID_USUARIO;
                
                SELECT 'ERROR' AS RESULTADO, 'USUARIO/CONTRASEÑA INVÁLIDOS' AS MENSAJE, NULL AS ID_USUARIO, FALSE AS REQUIERE_2FA;
            ELSE
                -- Login exitoso
                -- Reiniciar intentos fallidos y actualizar última conexión
                UPDATE TBL_MS_USUARIO 
                SET INTENTOS_FALLIDOS = 0,
                    INTENTOS_2FA_FALLIDOS = 0,
                    BLOQUEO_2FA_HASTA = NULL,
                    FECHA_ULTIMA_CONEXION = CURRENT_TIMESTAMP,
                    FECHA_MODIFICACION = CURRENT_TIMESTAMP,
                    USUARIO_MODIFICACION = 'SISTEMA'
                WHERE ID_USUARIO = v_ID_USUARIO;
                
                -- Verificar si es primer ingreso
                SET v_ES_PRIMER_INGRESO = (v_ESTADO = 'NUEVO');
                
                -- Si 2FA está activo, indicar que se requiere código
                IF v_ACTIVO_2FA = 1 THEN
                    SELECT 'REQUIERE_2FA' AS RESULTADO, 'SE REQUIERE CÓDIGO DE AUTENTICACIÓN DE DOS FACTORES' AS MENSAJE, 
                           v_ID_USUARIO AS ID_USUARIO, TRUE AS REQUIERE_2FA;
                ELSE
                    SELECT 'EXITO' AS RESULTADO, 'LOGIN EXITOSO' AS MENSAJE, v_ID_USUARIO AS ID_USUARIO, 
                           FALSE AS REQUIERE_2FA, v_ES_PRIMER_INGRESO AS PRIMER_INGRESO;
                END IF;
            END IF;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_bitacora_completa`
--

/*!50001 DROP VIEW IF EXISTS `vw_bitacora_completa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_bitacora_completa` AS select `b`.`ID_BITACORA` AS `ID_BITACORA`,`b`.`FECHA_HORA` AS `FECHA_HORA`,coalesce(`u`.`USUARIO`,'SISTEMA') AS `USUARIO`,coalesce(`u`.`NOMBRE_USUARIO`,'SISTEMA') AS `NOMBRE_USUARIO`,coalesce(`r`.`ROL`,'SISTEMA') AS `ROL`,`b`.`ACCION` AS `ACCION`,`b`.`DESCRIPCION` AS `DESCRIPCION`,`b`.`MODULO` AS `MODULO`,`b`.`TABLA_AFECTADA` AS `TABLA_AFECTADA`,`b`.`ID_REGISTRO_AFECTADO` AS `ID_REGISTRO_AFECTADO`,`b`.`IP_CLIENTE` AS `IP_CLIENTE`,`b`.`ESTADO_OPERACION` AS `ESTADO_OPERACION`,`b`.`DETALLE_ERROR` AS `DETALLE_ERROR`,`b`.`USER_AGENT` AS `USER_AGENT` from ((`tbl_ms_bitacora` `b` left join `tbl_ms_usuario` `u` on((`b`.`ID_USUARIO` = `u`.`ID_USUARIO`))) left join `tbl_ms_roles` `r` on((`u`.`ID_ROL` = `r`.`ID_ROL`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_citas_completas`
--

/*!50001 DROP VIEW IF EXISTS `vw_citas_completas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_citas_completas` AS select `c`.`ID_CITA` AS `ID_CITA`,`c`.`FECHA_CITA` AS `FECHA_CITA`,`c`.`FECHA_FIN_ESTIMADA` AS `FECHA_FIN_ESTIMADA`,`c`.`ESTADO` AS `ESTADO_CITA`,`c`.`PRIORIDAD` AS `PRIORIDAD`,`c`.`TIPO_CITA` AS `TIPO_CITA`,`p`.`ID_PACIENTE` AS `ID_PACIENTE`,concat(`p`.`NOMBRES`,' ',`p`.`APELLIDOS`) AS `NOMBRE_PACIENTE`,`p`.`TELEFONO` AS `TELEFONO`,`p`.`CORREO_ELECTRONICO` AS `CORREO_ELECTRONICO`,`u`.`ID_USUARIO` AS `ID_DOCTOR`,`u`.`NOMBRE_USUARIO` AS `NOMBRE_DOCTOR`,coalesce(`e`.`NOMBRE_ESPECIALIDAD`,'SIN ESPECIALIDAD') AS `NOMBRE_ESPECIALIDAD`,`c`.`MOTIVO_CONSULTA` AS `MOTIVO_CONSULTA`,`c`.`OBSERVACIONES` AS `OBSERVACIONES` from ((((`tbl_citas` `c` join `tbl_paciente` `p` on((`c`.`ID_PACIENTE` = `p`.`ID_PACIENTE`))) join `tbl_ms_usuario` `u` on((`c`.`ID_DOCTOR` = `u`.`ID_USUARIO`))) left join `tbl_doctor_especialidad` `de` on(((`u`.`ID_USUARIO` = `de`.`ID_DOCTOR`) and (`de`.`ES_PRIMARIA` = true)))) left join `tbl_especialidades` `e` on((`de`.`ID_ESPECIALIDAD` = `e`.`ID_ESPECIALIDAD`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_estadisticas_bitacora`
--

/*!50001 DROP VIEW IF EXISTS `vw_estadisticas_bitacora`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_estadisticas_bitacora` AS select cast(`tbl_ms_bitacora`.`FECHA_HORA` as date) AS `FECHA`,`tbl_ms_bitacora`.`MODULO` AS `MODULO`,`tbl_ms_bitacora`.`ESTADO_OPERACION` AS `ESTADO_OPERACION`,count(0) AS `TOTAL_OPERACIONES`,count(distinct `tbl_ms_bitacora`.`ID_USUARIO`) AS `USUARIOS_ACTIVOS` from `tbl_ms_bitacora` group by cast(`tbl_ms_bitacora`.`FECHA_HORA` as date),`tbl_ms_bitacora`.`MODULO`,`tbl_ms_bitacora`.`ESTADO_OPERACION` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_estado_seguridad_2fa`
--

/*!50001 DROP VIEW IF EXISTS `vw_estado_seguridad_2fa`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_estado_seguridad_2fa` AS select `u`.`ID_USUARIO` AS `ID_USUARIO`,`u`.`USUARIO` AS `USUARIO`,`u`.`NOMBRE_USUARIO` AS `NOMBRE_USUARIO`,`u`.`ACTIVO_2FA` AS `ACTIVO_2FA`,`u`.`FECHA_ACTIVACION_2FA` AS `FECHA_ACTIVACION_2FA`,`u`.`INTENTOS_2FA_FALLIDOS` AS `INTENTOS_2FA_FALLIDOS`,`u`.`BLOQUEO_2FA_HASTA` AS `BLOQUEO_2FA_HASTA`,`r`.`ROL` AS `ROL`,(case when (`u`.`ACTIVO_2FA` = 1) then 'PROTEGIDO' else 'VULNERABLE' end) AS `ESTADO_SEGURIDAD` from (`tbl_ms_usuario` `u` join `tbl_ms_roles` `r` on((`u`.`ID_ROL` = `r`.`ID_ROL`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_usuarios_completos`
--

/*!50001 DROP VIEW IF EXISTS `vw_usuarios_completos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_usuarios_completos` AS select `u`.`ID_USUARIO` AS `ID_USUARIO`,`u`.`USUARIO` AS `USUARIO`,`u`.`NOMBRE_USUARIO` AS `NOMBRE_USUARIO`,`u`.`ESTADO` AS `ESTADO`,`u`.`CORREO_ELECTRONICO` AS `CORREO_ELECTRONICO`,`u`.`FECHA_ULTIMA_CONEXION` AS `FECHA_ULTIMA_CONEXION`,`u`.`FECHA_VENCIMIENTO` AS `FECHA_VENCIMIENTO`,`u`.`INTENTOS_FALLIDOS` AS `INTENTOS_FALLIDOS`,`u`.`ACTIVO_2FA` AS `ACTIVO_2FA`,`u`.`FECHA_ACTIVACION_2FA` AS `FECHA_ACTIVACION_2FA`,`u`.`INTENTOS_2FA_FALLIDOS` AS `INTENTOS_2FA_FALLIDOS`,`u`.`BLOQUEO_2FA_HASTA` AS `BLOQUEO_2FA_HASTA`,`r`.`ROL` AS `ROL`,`r`.`DESCRIPCION` AS `DESCRIPCION_ROL` from (`tbl_ms_usuario` `u` join `tbl_ms_roles` `r` on((`u`.`ID_ROL` = `r`.`ID_ROL`))) */;
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

-- Dump completed on 2025-11-28 20:05:20
