CREATE TABLE `pk_logtransacciones` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Remitente` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `Receptor` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `TimeStamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1313 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;