
/* create database*/

create database `auctionweb_1753102`;
use `auctionweb_1753102`;

/* create table */

CREATE TABLE `account` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Username` text COLLATE utf8mb4_bin NOT NULL,
  `Password` text COLLATE utf8mb4_bin NOT NULL,`AccType` int(11) NOT NULL DEFAULT '0',
  `Point` int(11) DEFAULT NULL,
  `Name` text COLLATE utf8mb4_bin NOT NULL,
  `Address` text COLLATE utf8mb4_bin,
  `Birthday` date DEFAULT NULL,
  `Email` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
;



CREATE TABLE `catagory` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` text NOT NULL,
  `DateCreate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`),
  FULLTEXT KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;



CREATE TABLE `product` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` text NOT NULL,
  `CatId` int(11) NOT NULL,
  `StartTime` datetime DEFAULT CURRENT_TIMESTAMP,
  `StartPrice` int(11) NOT NULL,
  `EndTime` datetime NOT NULL,
  `EndPrice` int(11) DEFAULT NULL,
  `OwnerId` int(11) NOT NULL,
  `WinnerId` int(11) DEFAULT NULL,
  `CurrentPrice` int(11) DEFAULT NULL,
  `IsAutoExtend` int(11) DEFAULT '0',
  `IsInstantBought` int(11) DEFAULT '0',
  `ImageFolder` text,
  `IsRestrictBidder` int(11) DEFAULT '1',
  `PriceStep` int(11) NOT NULL,
  `Description` text,
  PRIMARY KEY (`Id`),
  KEY `CatId` (`CatId`),
  KEY `product_ibfk_2` (`OwnerId`),
  KEY `product_ibfk_3` (`WinnerId`),
  FULLTEXT KEY `Name` (`Name`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`CatId`) REFERENCES `catagory` (`Id`),
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`OwnerId`) REFERENCES `account` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `product_ibfk_3` FOREIGN KEY (`WinnerId`) REFERENCES `account` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;


CREATE TABLE `bidderproduct` (
  `BidderId` int(11) NOT NULL,
  `ProId` int(11) NOT NULL,
  `Price` int(11) NOT NULL,
  `AutoMaxPrice` int(11) DEFAULT NULL,
  `DateCreate` datetime DEFAULT CURRENT_TIMESTAMP,
  `IsWin` int(11) DEFAULT '0',
  `IsBanned` int(11) DEFAULT '0',
  KEY `bidderproduct_ibfk_1` (`BidderId`),
  KEY `bidderproduct_ibfk_2` (`ProId`),
  CONSTRAINT `bidderproduct_ibfk_1` FOREIGN KEY (`BidderId`) REFERENCES `account` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `bidderproduct_ibfk_2` FOREIGN KEY (`ProId`) REFERENCES `product` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;


CREATE TABLE `commentrate` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `FromId` int(11) NOT NULL,
  `ToId` int(11) NOT NULL,
  `Point` int(11) NOT NULL,
  `Message` text NOT NULL,
  `DateCreate` datetime DEFAULT CURRENT_TIMESTAMP,
  `ProId` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `commentrate_ibfk_1` (`FromId`),
  KEY `commentrate_ibfk_2` (`ToId`),
  CONSTRAINT `commentrate_ibfk_1` FOREIGN KEY (`FromId`) REFERENCES `account` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `commentrate_ibfk_2` FOREIGN KEY (`ToId`) REFERENCES `account` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

CREATE TABLE `upgraderequest` (
  `FromId` int(11) NOT NULL,
  `DateCreate` datetime DEFAULT CURRENT_TIMESTAMP,
  KEY `upgraderequest_ibfk_1` (`FromId`),
  CONSTRAINT `upgraderequest_ibfk_1` FOREIGN KEY (`FromId`) REFERENCES `account` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;


CREATE TABLE `watchlist` (
  `AccountId` int(11) NOT NULL,
  `ProId` int(11) NOT NULL,
  KEY `watchlist_ibfk_1` (`AccountId`),
  KEY `watchlist_ibfk_2` (`ProId`),
  CONSTRAINT `watchlist_ibfk_1` FOREIGN KEY (`AccountId`) REFERENCES `account` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `watchlist_ibfk_2` FOREIGN KEY (`ProId`) REFERENCES `product` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

/* insert data */

/* account */

INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('67','user1','user1','1','0','Nguyen Van Hoa',' ','2019-12-20','thang@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('68','admin','admin2','3','0','Quản Trị Viên',' ','2019-12-20','admin@x.mail');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('69','thangseller','$2a$10$8ve3pf7O22I9qAGUFhEe.e2sAxkbjkU8USfn3VQL6Zqekxq6ohuHO','2','3','ThangSeller',' ','2019-12-20','khacviet34567@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('70','df','f','0','0','Nguyễn Hữu Dũng',' ','2019-12-20','dv@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('92','irous12345','$2a$10$8ve3pf7O22I9qAGUFhEe.e2sAxkbjkU8USfn3VQL6Zqekxq6ohuHO','1','7','Bùi Quang Thắng','77 tran phu, P.23, QBinh Thanh','2020-02-29','khacviet34567@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('93','xcxzcxzvcvbcx','$2a$10$KDCfwuRTlZcv5zYY9g3atu2Fa6c6bSHyYhVxftWkrDIFZra541GiC','1','0',' Phan Bình','  ','2019-12-20','Thag7@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('97','th334dksf','$2a$10$W3rxYLNHW2F1z2kWp0bwauX7AqJyqwaOuzrYdkVDRdoHTLuLn8WbG','1','0','Lê Thanh Duy',' ','2019-12-20','anhduyxxzc@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('98','thhangad3456765','$2a$10$prlsbz7L.HoWKdmVWV652.0GB2ZwSSHlIrqb87fqfTuDAO9wpYVDi','0','0','Huỳnh Minh Tú',' ','2019-12-20','Thag1343@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('99','thhangadcvcv','$2a$10$npxE2DP.VWYlTMB8osZp9.R1ERgH6aC9LRQ0Tqd0JhsNZHTDWgoAG','1','0','Phạm Thị Bích Ngọc',' ','2019-12-20','Thag76543@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('103','irous23435656','$2a$10$/iH/mCRA9iPva5LT7iisSu0rN9mJ0vigJDbJQ1Th1/k7Bf2tD4/Ba','1','0','Phạm Hoàng An',' ','2019-12-20','Thagijtgb@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('104','5tg5rg','$2a$10$z37TZKD01kWfpYbCvdsaSeV49XgE9FVxWYUTqXSrOByliQ8QfW8aC','0','0','Nguyễn Hoàng Gia Bảo',' ','2019-12-20','Thagz@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('105','irousqt2345','$2a$10$C6ro.YqJ/gvGAMhIiLV8teNzYHXdz.c.qb/HU475Wah4pByF6QqdK','0','0','Nguyễn Minh Nhựt',' ','2019-12-20','Thagb@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('106','irousqt2345','$2a$10$LnXJDtj45jun2oeDV.2N8OqLiwd8..YVPuoRb5yweOdDtl.6HrRpW','1','0','Trần Thanh Tân',' ','2019-12-20','Thagb@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('107','dsfdsfdsf12345','$2a$10$xgEslPVUmd9UFrHUxHavoemAnVdPUw9uuT1AMmyNc448g/1an8elS','1','0','Nguyễn Đặng Thế Quang','  ','2019-12-20','thangbui1234@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('108','thhangad65tyh8','$2a$10$IlxSBh6hbaNIdSyspbz5F.kZjENBQ/q8REF/fipzdWpS.Jo0ZYrs2','0','0','Huỳnh Hà Mai Trinh',' ','2019-12-20','thangbuith8765@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('109','irous2343vfg4','$2a$10$IjqjamPsBk6BRUNczPlay.nENFiuBBzotobPSdESMfjguem8D2pXm','0','0','Trần Đình Tú',' ','2019-12-20','Thang423@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('110','thhangad234565gfd','$2a$10$YoavY4QYLw5nNo0mSGt89OPNvbOGEo79UN.EsgFp9hJlqWKuQbOn.','0','0','Trương Hữu Đức',' ','2019-12-20','Thagcv456@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('111','thhangad34567ygfhnbf','$2a$10$FgkZiKepNnClGuvhe6eCJOR3SNj6p3GmiVssl7IWLplLeKkLcMLqO','0','0','Trịnh Tuấn Kiệt',' ','2019-12-20','Thagkh@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('112','hhhhjjj','$2a$10$fD3sasRs8d8hDIZijVrhV.r3sVcpP7VRcGHc8PkomYo73zoS6m7Lq','0','0','Nguyễn Minh Quang',' ','2019-12-20','Thadsf4tetgg@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('113','hhhhjjjdr','$2a$10$lWwAsO7AkvMQREQWMv/9cO2cMnvEF3R1/Md683Wl.cseoqd53Vuu.','0','0','Nguyễn Võ Hồng',' ','2019-12-20','Thadsf4tetgfdeg@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('114','irousirous','$2a$10$TTjaPPPEj3xm3E1HCQNOFOSCSGYH95.SyNh0K4jQ1urlZjnPyZXYa','2','4','Mr IrousVip33','204 Tran Phu, Quan Binh Tan','1999-02-28','khacviet34567@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('115','adminx','$2a$10$I4LW9BamdVMuSKHW5jNjWOzycMeAXQtloCMhQM6ZEgJKwgzddPTMq','3','0','Quản Trị Viên','','2020-01-23','khacviet34567@gmail.com');
INSERT INTO `auctionweb_1753102`.`account` (`Id`,`Username`,`Password`,`AccType`,`Point`,`Name`,`Address`,`Birthday`,`Email`) VALUES ('116','newuser123','$2a$10$bkgoKs7PJxEqrfkbcq.Lu.aIe3BCiLknwE0cEJhijCEYZkjCWwxrS','2',NULL,'Bùi Thắng Quang Tâm','23 Standford, New York','1999-01-16','1753102@student.hcmus.edu.vn');



/* catagory */

INSERT INTO `auctionweb_1753102`.`catagory` (`Id`,`Name`,`DateCreate`) VALUES ('67','Laptop','2019-12-17 23:16:08');
INSERT INTO `auctionweb_1753102`.`catagory` (`Id`,`Name`,`DateCreate`) VALUES ('68','Smart phone','2019-12-17 23:16:08');
INSERT INTO `auctionweb_1753102`.`catagory` (`Id`,`Name`,`DateCreate`) VALUES ('69','Car','2019-12-20 01:29:29');
INSERT INTO `auctionweb_1753102`.`catagory` (`Id`,`Name`,`DateCreate`) VALUES ('70','Game gear','2019-12-20 01:29:29');
INSERT INTO `auctionweb_1753102`.`catagory` (`Id`,`Name`,`DateCreate`) VALUES ('71','Clothes','2019-12-20 02:26:30');
INSERT INTO `auctionweb_1753102`.`catagory` (`Id`,`Name`,`DateCreate`) VALUES ('72','House','2019-12-20 02:26:30');

/* product */


INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('106','Laptop Acer Aspire 3 A315-54K-36QU (NX.HEESV.007) (15" FHD/i3-7020U/4GB/256GB SSD/HD 620/Win10/1.7 kg)','67','2020-01-04 09:24:17','15699000','2020-01-10 18:10:10',NULL,'69','92','21699000','0',NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Acer Aspire A315-54K-36QU (NX.HEESV.007) (i3-7020U) (Đen)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('107','Laptop ASUS ROG Strix G G531GD-AL025T (15" FHD/i5-9300H/8GB/512GB SSD/GTX 1050/Win10/2.4 kg)','67','2020-01-04 09:24:17','13699000','2020-01-10 18:10:10',NULL,'69','114','18699000','1',NULL,' /images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Asus ROG Strix G531GD-AL025T (i5-9300H) (Đen)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('108','Laptop HP Pavilion 14-ce3013TU (8QN72PA) (14" FHD/i3-1005G1/4GB/256GB SSD/Intel UHD/Win10/1.6kg)','67','2020-01-04 09:24:17','16699000','2020-01-10 18:10:10',NULL,'69','114','20699000','1',NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop HP Pavilion 14-ce3013TU (8QN72PA) (i3-1005G1) (Bạc)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('109','Laptop Acer Aspire 5 A515-54-54EU (NX.HN3SV.002) (15" FHD/i5-10210U/8GB/512GB SSD/UHD 620/Win10/1.7 kg)','67','2020-01-04 09:24:17','10699000','2020-01-10 18:10:10',NULL,'69','116','15699000','0',NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Acer Aspire 5 A515-54-54EU (NX.HN3SV.002) (i5-10210U) (Bạc)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('110','Laptop Acer Swift 3 SF314-56-38UE (NX.H4CSV.005) (14" FHD/i3-8145U/4GB/256GB SSD/UHD 620/Win10/1.5 kg)','67','2020-01-04 09:24:17','10699000','2020-01-10 18:10:10',NULL,'69','114','14699000','0',NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Acer Swift 3 SF314-56-38UE (NX.H4CSV.005) (i3-8145U) (Bạc)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('111','Laptop MSI GF63 Thin 9RCX-646VN (15" FHD/i5-9300H/8GB/512GB SSD/GTX 1050Ti/Win10/1.9 kg)','67','2020-01-04 09:24:17','21699000','2020-01-10 18:10:10',NULL,'69','116','26699000',NULL,NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop MSI GF63 9RCX-646VN (i5-9300H) (Đen)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('112','Laptop HP 14s (7VH92PA) (14" HD/R3-3200U/4GB/1TB HDD/Radeon Vega 3/Win10/1.5 kg)','67','2020-01-04 09:24:17','15699000','2020-01-10 18:10:10',NULL,'69','92','19699000',NULL,NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop HP 14s-dk0097AU (7VH92PA) (AMD Ryzen 3 3200U) (Bạc)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('113','Laptop Lenovo Ideapad 330-15KBR (81DE0278VN) (15.6" HD/i3-8130U/4GB/1TB HDD/UHD 620/Free DOS/2.2 kg)','67','2020-01-04 09:24:17','14449000','2020-01-10 18:10:10',NULL,'69','114','18449000',NULL,NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Lenovo Ideapad 330-15IKB 81DE0278VN (i3-8130U) (Xám)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('114','Laptop Acer Swift 3 SF315-52-38YQ (NX.GZBSV.003) (15.6" FHD/i3-8130U/4GB/1TB HDD/UHD 620/Win10/1.6 kg)','67','2020-01-04 09:24:17','17699000','2020-01-07 18:10:10',NULL,'69',NULL,NULL,'0',NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Acer Swift 3 SF315-52-38YQ (NX.GZBSV.003) (Vàng)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('115','Laptop ASUS ZenBook 13 UX333FA-A4046T (13.3" FHD/i5-8265U/8GB/256GB SSD/UHD 620/Win10/1.2 kg)','67','2020-01-04 09:24:17','18699000','2020-01-10 17:10:10','50000000','69','92','23699000',NULL,'1','/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Asus Zenbook UX333FA-A4046T (i5-8265U) (Bạc)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('116','Laptop Dell Vostro 3480-2K47M1 (14" HD/i5-8265U/4GB/1TB HDD/Radeon 520/Win10/1.8 kg)','67','2020-01-04 09:24:17','19699000','2020-01-09 12:10:10',NULL,'114',NULL,NULL,'1',NULL,'/images/products','0','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Dell Vostro 14 3480 (3480-2K47M1) (i5-8265U) (Đen)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('117','Laptop ASUS ZenBook 13 UX333FA-A4011T','67','2020-01-04 09:24:17','20699000','2020-01-10 01:00:00','50000000','114',NULL,NULL,'1','1','/images/products','1','1000000','Tên sản phẩm: Máy tính xách tay/ Laptop Asus Zenbook UX333FA-A4011T (I5-8265U) (Xanh)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('141','efwesf2','67','2020-01-07 15:44:13','100','2020-01-18 04:04:00',NULL,'114',NULL,NULL,'0','0','/images/products','0','50','
						
						
						
						
						
						
						
						
						
						
						
						
					<br>---7/1/2020, 16:33---<br><p>Hello, World!</p><br>---7/1/2020, 16:33---<br><p><span style="background-color: #e03e2d;">Hello, World!222</span></p>
					<br>---7/1/2020, 16:35---<br><p>Hello, World!sdfdsf</p><br>---7/1/2020, 16:35---<br><ol>
<li style="text-align: center;"><em><strong><span style="background-color: #e03e2d;">Hello, World!</span><span style="background-color: #e03e2d;">Hello, World!</span><span style="background-color: #e03e2d;">Hello, World!</span></strong></em></li>
<li style="text-align: center;"><em><strong><span style="background-color: #e03e2d;">Hello, World!</span></strong></em></li>
<li style="text-align: center;"><em><strong><span style="background-color: #e03e2d;">Hello, World!</span></strong></em></li>
<li style="text-align: center;"><em><strong><span style="background-color: #e03e2d;">Hello, World!</span></strong></em></li>
</ol>
<p>&nbsp;</p>
					<br>---7/1/2020, 16:37---<br><p>Hello, World!sdfds</p>
					<br>---7/1/2020, 16:38---<br><p style="text-align: right;">Hello, World!dsf</p>
					<br>---7/1/2020, 16:38---<br><ul>
<li style="text-align: right;"><strong>dsfdsfdsf</strong></li>
</ul>
					<br>---7/1/2020, 16:39---<br><ul>
<li><span style="color: #e03e2d;"><strong>Hello, World!</strong></span></li>
</ul>
					<br>---7/1/2020, 16:45---<br><p style="text-align: justify;"><strong>Hello, World!</strong></p>
					<br>---7/1/2020, 17:07---<br><p><span style="background-color: #f1c40f; color: #169179;">Hello, World!#3</span></p>
					<br>---7/1/2020, 17:09---<br><p>Hello, World!</p>
					<br>---7/1/2020, 17:09---<br><p>Hello, World!</p>
					<br>---7/1/2020, 17:09---<br><p>Hello, World!af</p>
					<br>---7/1/2020, 17:12---<br><p><span style="background-color: #169179;">Hello, World!#99</span></p>');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('142','33333','67','2020-01-07 15:44:13','100','2020-01-18 04:04:00',NULL,'114',NULL,NULL,'0','0','/images/products','0','50','
						
						
						
						
						
						
						
						
						
						
						
						
					<br>---7/1/2020, 16:33---<br><p>Hello, World!</p><br>---7/1/2020, 16:33---<br><p><span style="background-color: #e03e2d;">Hello, World!222</span></p>
					<br>---7/1/2020, 16:35---<br><p>Hello, World!sdfdsf</p><br>---7/1/2020, 16:35---<br><ol>
<li style="text-align: center;"><em><strong><span style="background-color: #e03e2d;">Hello, World!</span><span style="background-color: #e03e2d;">Hello, World!</span><span style="background-color: #e03e2d;">Hello, World!</span></strong></em></li>
<li style="text-align: center;"><em><strong><span style="background-color: #e03e2d;">Hello, World!</span></strong></em></li>
<li style="text-align: center;"><em><strong><span style="background-color: #e03e2d;">Hello, World!</span></strong></em></li>
<li style="text-align: center;"><em><strong><span style="background-color: #e03e2d;">Hello, World!</span></strong></em></li>
</ol>
<p>&nbsp;</p>
					<br>---7/1/2020, 16:37---<br><p>Hello, World!sdfds</p>
					<br>---7/1/2020, 16:38---<br><p style="text-align: right;">Hello, World!dsf</p>
					<br>---7/1/2020, 16:38---<br><ul>
<li style="text-align: right;"><strong>dsfdsfdsf</strong></li>
</ul>
					<br>---7/1/2020, 16:39---<br><ul>
<li><span style="color: #e03e2d;"><strong>Hello, World!</strong></span></li>
</ul>
					<br>---7/1/2020, 16:45---<br><p style="text-align: justify;"><strong>Hello, World!</strong></p>
					<br>---7/1/2020, 17:07---<br><p><span style="background-color: #f1c40f; color: #169179;">Hello, World!#3</span></p>
					<br>---7/1/2020, 17:09---<br><p>Hello, World!</p>
					<br>---7/1/2020, 17:09---<br><p>Hello, World!</p>
					<br>---7/1/2020, 17:09---<br><p>Hello, World!af</p>
					<br>---7/1/2020, 17:12---<br><p><span style="background-color: #169179;">Hello, World!#99</span></p>');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('144','MY San Dau Gia','67','2020-01-09 01:18:57','100','2020-01-11 16:46:10',NULL,'114',NULL,NULL,'0','0','/images/products','0','50','<p>This is product description</p>');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('145','May Tinh xach tay lau','67','2020-01-09 01:20:09','100','2020-01-17 02:22:00',NULL,'114',NULL,NULL,'0','0','/images/products','1','50','<p>This is product description</p>');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('146','Điện thoại iPhone 11 Pro Max 512GB MWHR2VN/A (Midnight Green)','68','2020-01-10 02:57:51','39999000','2020-01-11 02:22:00',NULL,'69','114','90899000','0',NULL,'/images/products','0','100000','Apple chính thức ra mắt điện thoại Iphone 11 Pro Max vào ngày 11/9 với nhiều điểm nhấn đến từ thiết kế. Cụm camera mới, bên cạnh đó Apple ra mắt phiên bản chip nhanh nhất hiện nay A13, tích hợp IOS 13 giúp nâng cao trải nghiệm người dùng.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('147','Điện thoại iPhone 11 Pro Max 512GB MWHQ2VN/A (Gold)','68','2020-01-10 02:57:52','39999000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Apple chính thức ra mắt điện thoại Iphone 11 Pro Max vào ngày 11/9 với nhiều điểm nhấn đến từ thiết kế. Cụm camera mới, bên cạnh đó Apple ra mắt phiên bản chip nhanh nhất hiện nay A13, tích hợp IOS 13 giúp nâng cao trải nghiệm người dùng.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('148','Điện thoại iPhone 11 Pro Max 256GB MWHK2VN/A (Silver)','68','2020-01-10 02:57:52','34699000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Apple chính thức ra mắt điện thoại Iphone 11 Pro Max vào ngày 11/9 với nhiều điểm nhấn đến từ thiết kế. Cụm camera mới, bên cạnh đó Apple ra mắt phiên bản chip nhanh nhất hiện nay A13, tích hợp IOS 13 giúp nâng cao trải nghiệm người dùng.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('149','Máy tính bảng Samsung Galaxy Tab A8 8" T295 (2019) (SM-T295NZKAXEV) (Đen)','68','2020-01-10 02:57:53','3690000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Samsung Galaxy Tab A8 8" T295 ấn tượng với kiểu dáng thời thượng trẻ trung, với vỏ nhựa nhẹ cùng góc bo tròn mang lại cảm giác chắc chắn, không bám vân tay khi cầm. Kích thước vừa tay, nhỏ gọn giúp người dùng thoải mái thao tác, cùng bạn đồng hành đến khắp mọi nơi.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('150','Điện thoại Realme 5 Pro 4GB/128GB (Xanh lam, Tím)','68','2020-01-10 02:57:53','5490000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Chụp toàn cảnh để lưu giữ trọn vẹn từng khoảnh khắc cùng hệ thống bộ bốn camera Sony tuyệt đỉnh trên Realme 5 Pro 4GB/128GB (Xanh tím). Camera chính có độ phân giải 48MP đem lại mọi bức hình với chi tiết rõ ràng và sắc nét. Camera cảm biến chiều sâu giúp bạn có thể chụp xóa phông một cách chuyên nghiệp. Camera góc siêu rộng có thể chụp khung hình góc rộng lên đến 119° đem lại những bức hình đầy ấn tượng. Camera góc siêu cận giúp chụp những bức ảnh đặc tả cận cảnh chi tiết cực kỳ sắc nét.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('151','Điện thoại XIAOMI Redmi Note 8 4GB/128GB (Xanh lam)','68','2020-01-10 02:57:53','5090000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Xiaomi Redmi Note 8 là một sản phẩm smartphone tầm trung mới được ra mắt của Xiaomi với nhiều cải tiến. Đặc điểm nổi bật nhất đó chính là hệ thống 4 camera chất lượng và cấu hình cực kỳ tốt.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('152','Điện thoại SAMSUNG Galaxy A30s 4GB/64GB (Trắng)','68','2020-01-10 02:57:53','5690000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Với thiết kế sang trọng từ Điện thoại Galaxy A30s với độ mỏng 7.7mm ấn tượng kết hợp cùng mặt lưng cao cấp 3D cho hiệu ứng cao cấp chuyển đổi màu sắc theo góc nhìn. Ngoài ra các cạnh máy được bo cong mềm mại giúp khả năng cầm nắm được mềm mại hơn. Được tối ưu viền rất tốt ở 4 cạnh, cùng tấm nền supper AMOLED 6.4 inches, HD+ giúp cho trải nghiệm của bạn được tuyệt vời hơn.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('153','Điện thoại SAMSUNG Galaxy A20s 3GB/32GB (Đỏ)','68','2020-01-10 02:57:53','4090000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Màn hình tràn viền Infinity-V 6.5-inch siêu rộng giúp nâng tầm trải nghiệm thị giác của bạn lên một tầm cao mới. Tuyệt tác điện thoại SAMSUNG Galaxy A20s (Đỏ) với thiết kế gần như không viền đem đến thế giới giải trí sống động ngay trước mắt bạn mọi lúc mọi nơi.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('154','Điện thoại SAMSUNG Galaxy A20s 3GB/32GB (Xanh lục)','68','2020-01-10 02:57:53','3999000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Màn hình tràn viền Infinity-V 6.5-inch siêu rộng giúp nâng tầm trải nghiệm thị giác của bạn lên một tầm cao mới. Tuyệt tác điện thoại SAMSUNG Galaxy A20s (Xanh lục) với thiết kế gần như không viền đem đến thế giới giải trí sống động ngay trước mắt bạn mọi lúc mọi nơi.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('155','Điện thoại XIAOMI Redmi Note 8 4GB/64GB (Trắng)','68','2020-01-10 02:57:54','4599000','2020-01-17 02:22:00','50000000','69','92','50999000',NULL,'1','/images/products','0','100000','Xiaomi Redmi Note 8 là một chiếc điện thoại tầm trung mới được ra mắt của Xiaomi với thiết kế ấn tượng cùng với hiệu năng cực kỳ cao kèm theo đó là cụm 4 camera được xếp dọc bắt mắt.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('156','Điện thoại XIAOMI Redmi Note 8 4GB/64GB (Đen)','68','2020-01-10 10:55:54','4599000','2020-01-17 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Tên sản phẩm: Điện Thoại Di Động Xiaomi Redmi Note 8 (4+64GB) (Đen)');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('158','Chuột máy tính không dây Microsoft Wireless Mobile Mouse 1850 (Đen)','70','2020-01-10 04:11:07','299000','2020-01-11 02:22:00',NULL,'69','92','699000',NULL,NULL,'/images/products','0','100000','Chuột máy tính Microsoft Wireless Mobile Mouse 1850 được sản xuất bởi hãng Microsoft, một ông lớn chuyên về phần mềm và các thiết bị ngoại vi dành cho dân văn phòng và game thủ. Các sản phẩm từ Microsoft đều có được chất lượng cao và giá thành phải chăng cho người tiêu dùng.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('159','Bàn phím FL Esports K180R Led (Đen Bạc)','70','2020-01-10 04:11:07','1220000','2020-01-11 02:22:00',NULL,'69','114','1620000',NULL,NULL,'/images/products','0','100000','Bàn phím FL ESports K180R Led được thiết kế với khung được làm từ kim loại chắc chắn, bề mặt nhẵn, mượt mà, được đánh bóng sang trọng. Cùng với các keycap được làm từ nhựa cao cấp chắc chắn với công nghệ mới đảm bảo tuổi thọ lâu dài cho thiết bị, không bị mờ phím sau thời gian dài.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('160','Bàn phím FL Esports K180R Led (Trắng Bạc)','70','2020-01-10 04:11:07','1220000','2020-01-11 02:22:00',NULL,'69','114','1620000',NULL,NULL,'/images/products','0','100000','FL ESports là nhà sản xuất thiết bị ngoại vi dành cho game thủ có trụ sở chính được đặt tại Trung Quốc. Với giá thành tầm trung nhưng mang lại chất lượng và mẫu mã đa dạng phù hợp với đa số game thủ trong thời điểm hiện tại. Ngày càng lớn mạnh trong thị trường, FL ESports hứa hẹn sẽ đem lại nhiều những sản phẩm chất lượng hơn trong tương lai.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('161','Miếng lót chuột Dareu ESP100 (Size M/5mm)','70','2020-01-10 04:11:07','149000','2020-01-11 02:22:00',NULL,'69','92','549000',NULL,NULL,'/images/products','0','100000','Miếng lót chuột Dareu ESP100 sở hữu một thiết kế thanh lịch, độc đáo với hình in vô cùng ấn tượng, tạo cho game thủ một cảm giác chuyên nghiệp và thích thú khi trải nghiệm sản phẩm.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('162','Chuột gaming CorSAIR Ironclaw','70','2020-01-10 04:11:07','1790000','2020-01-11 02:22:00',NULL,'69','92','2190000',NULL,NULL,'/images/products','0','100000','Corair là một thương hiệu không còn xa lạ gì với những game thủ trong thời điểm hiện tại. Với những sản phẩm chất lượng và giá cả hợp lý. Chuột gaming Corsair Ironclaw cũng là một trong những sản phẩm chất lượng với thiết kế gọn nhẹ chỉ 105g kèm theo đó là các đường vân 2 bên giúp cho khả năng cầm nắm được chắc chắn hơn.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('163','Dao làm bếp chuyên nghiệp với thiết kế mặt thép rỗ và cán gỗ sang trọng','72','2020-01-10 04:11:08','238000','2020-01-11 02:22:00',NULL,'69','114','738000',NULL,NULL,'/images/products','0','100000','Thép vanadi 7CR17 đảm bảo độ cứng từ 60-62HRC cho khả năng giữ lưỡi sắc tốt trong thời gian sử dụng dài, dao dễ mài bằng các công cụ thường dụng hoặc đá mài mặt kim cương. Vân Dasmacus được rèn tự nhiên bằng phương pháp chồng ghép các lớp thép có độ carbon cao với các lớp thép có độ carbon thấp tạo nên tính dẻo dai cho dao.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('164','kệ đựng xà bông, dao cạo râu có lỗ thoát nước hút chân không thông minh','72','2020-01-10 04:11:08','12000','2020-01-11 02:22:00',NULL,'69','114','412000',NULL,NULL,'/images/products','0','100000','Được thiết kế để chứa nhiều vật dụng nhỏ trong phòng tắm, chẳng hạn như xà phòng, xà phòng tắm, miếng bọt biển ... Thiết kế rãnh đa dạng và lỗ thoát nước để giữ cho người giữ sạch sẽ và khô ráo. Được làm bằng chất liệu nhựa pp có chất lượng cao, nhẹ, bền và đẹp.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('165','KHĂN TẮM XUẤT NHẬT CAO CẤP','72','2020-01-10 04:11:08','19000','2020-01-11 02:22:00',NULL,'69','92','419000',NULL,NULL,'/images/products','0','100000','Khăn tắm xuất Nhật này đẹp mê hồn luôn ạ... mềm, thấm nước, nhanh khô. Khăn này dùng quấn cho các bé cũng cứ gọi là ok lunnnn.... vì em ấy rất rất mềm ạ');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('166','Ga Chống Thấm Hàng Việt Nam KT 1M6 - 2M GIAO NGAU NHIÊN','72','2020-01-10 04:11:08','85000','2020-01-11 02:22:00',NULL,'69','92','485000',NULL,NULL,'/images/products','0','100000','Chất liệu nilong chống thấm ');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('167','Khăn tắm xuất nhật siêu mềm mịn','72','2020-01-10 04:11:08','17100','2020-01-11 02:22:00',NULL,'69','114','517100',NULL,NULL,'/images/products','0','100000','Khăn có 4 màu xanh, tím, vàng, hồng <br>Khổ rộng 70 * 140cm. Cực to. <br>Nhanh khô. Mềm. Mịn');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('168','Đồng hồ treo tường kim trôi cao cấp','72','2020-01-10 04:11:08','125000','2020-01-11 02:22:00',NULL,'69','114','825000',NULL,NULL,'/images/products','0','100000','Với cuộc sống hiện đại nhằm phục vụ tốt hơn cho nhu cầu cuộc sống của con người, đồng hồ đóng một vai trò quan trọng không chỉ là công cụ để theo dõi giờ giấc mà nó còn được coi như là một món đồ trang trí tinh tế thể hiện được đúng với phong cách, cá tính của chủ nhân của nó. ');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('169','Máy lọc không khí Daikin MC30VVM-A','72','2020-01-10 04:11:09','3890000','2020-01-11 02:22:00',NULL,'69','92','4190000',NULL,NULL,'/images/products','0','100000','Hiện nay mức độ ô nhiễm không khí ngày càng tăng trong đời sống hiện nay. Vì vậy việc có một chiếc máy lọc không khí để bảo vệ sức khỏe gia đình, nhất là trẻ em, phụ nữ có thai và người già. Nắm bắt được nhu cầu thiết yếu đó. Daikin đã cho ra mắt nhiều dòng máy phục vụ tối đa nhu cầu của mọi người.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('170','Máy giặt sấy Electrolux Inverter 11 kg EWW1141AEWA','72','2020-01-10 04:11:09','20590000','2020-01-11 02:22:00',NULL,'69','114','30990000',NULL,NULL,'/images/products','0','100000','Máy giặt sấy Electrolux Inverter 11 kg EWW1141AEWA có thiết kế khá cứng cáp với tông màu xám đen, đây là tông màu khá trang nhã và dễ phối với mọi không gian nội thất. Lớp vỏ được phũ một lớp sơn tĩnh điện dễ lau chùi, và vệ sinh giúp máy khá bền màu theo th\\ời gian.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('171','Máy Bắt Muỗi Remax RL-LF11 (Trắng)','72','2020-01-10 04:11:09','179000','2020-01-11 02:22:00',NULL,'69','92','679000',NULL,NULL,'/images/products','0','100000','Máy bắt muỗi RL-LF11 của Remax sở hữu kích thước nhỏ gọn với trọng lượng chỉ 577g với tay cầm hình tròn dễ cầm nắm, thân tay cầm được tích hợp các nút bấm và cổng sạc. Đi kèm theo đó là chân đế chắc chắn giúp bạn cố định sản phẩm ngay trên mặt bàn khi không sử dụng. Thân vợt bắt muỗi còn có đèn LED giúp bạn sử dụng trong bóng tối, có thể dùng ánh sáng để thu hút côn trùng.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('172','Tủ lạnh Panasonic Inverter 290 lít NR-BV320QSVN','72','2020-01-10 04:11:09','11590000','2020-01-11 02:22:00','50000000','69',NULL,NULL,NULL,'1','/images/products','0','100000','Tủ lạnh Panasonic Inverter 290 lít NR-BV320QSVN là chiếc tủ ngăn đá trên hiện đại và tiện lợi của nhà sản xuất Panasonic. Với thiết kế góc tủ phằng, không viền tạo nên sự tinh tế và sang trọng cho NR-BV320QSVN giúp cho không gian của bạn trở nên sang trọng hơn.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('173','Máy Phun Sương Remax RT-EM05','72','2020-01-10 04:11:09','280000','2020-01-11 02:22:00',NULL,'69',NULL,NULL,NULL,NULL,'/images/products','0','100000','Độ ồn tuyệt đối, đảm bảo để không làm phiền bạn khi đang làm việc hoặc nghỉ ngơi ');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('174','ÁO SƠ MI NAM DÀI TAY','71','2020-01-10 04:11:09','499000','2020-01-11 02:22:00',NULL,'69','92','899000',NULL,NULL,'/images/products','0','100000','Áo sơ mi chất liệu cotton. Phom regular, cổ đức, tay dài. Thích hợp mặc quanh năm. Kiểu dáng đơn giản, lịch sự phù hợp nhiều hoàn cảnh. Có thể phối với nhiều dáng quần: quần jeans, khak, giày lười, giày tây');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('175','ÁO LEN NAM','71','2020-01-10 04:11:09','449000','2020-01-11 02:22:00',NULL,'69','92','949000',NULL,NULL,'/images/products','0','100000','Áo len sợi dày pha wool. Phom regular, cổ tròn, tay dài. Áo dệt mặt hàng. Thích hợp mặc mùa đông. Kiểu dáng đơn giản, phù hợp nhiều hoàn cảnh. Dễ dàng kết hợp với quần jeans, khaki, giày lười,…');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('176','QUẦN JEANS NAM CHẤT LIỆU COTTON US','71','2020-01-10 04:11:09','699000','2020-01-11 02:22:00',NULL,'69','92','1199000',NULL,NULL,'/images/products','0','100000','Quần jeans chất liệu cotton US, co giãn. Phom slim, cạp thường, cài cúc, khóa phía trước. Có 5 túi, mài rách phía trước. Thích hợp mặc quanh năm. Phù hợp nhiều hoàn cảnh. Dễ dàng kết hợp với áo phông, áo sơ mi, giày thể thao, giày lười,…');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('177','ÁO PHÔNG NAM IN CHỮ','71','2020-01-10 04:11:09','299000','2020-01-11 02:22:00',NULL,'69','114','699000',NULL,NULL,'/images/products','0','100000','Áo phông cotton USA in chữ. Phom regular, cổ tròn, tay dài. Thích hợp mặc mùa thu đông. Kiểu dáng đơn giản, phù hợp nhiều hoàn cảnh.Có thể phối quần sóoc, jeans, khaki,giày thể thao…');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('178','QUẦN DÀI NAM','71','2020-01-10 04:11:09','449000','2020-01-11 02:22:00',NULL,'69','114','849000',NULL,NULL,'/images/products','0','100000','Quần nỉ cotton pha. Phom jogger, cạp chun có dây rút. Cạp và gấu quần bằng bo, can diễu thân trước. Thích hợp mặc mùa thu đông. Phù hợp nhiều hoàn cảnh. Có thể phối với áo phông, áo nỉ… và phối với phụ kiện giày thể thao, giày lười...');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('179','QUẦN NỈ NAM','71','2020-01-10 04:11:09','449000','2020-01-11 02:22:00',NULL,'69','114','849000',NULL,NULL,'/images/products','0','100000','Thích hợp mặc mùa thu đông. Phù hợp nhiều hoàn cảnh. Có thể phối với áo phông, áo nỉ… và phối với phụ kiện giày thể thao, giày lười...');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('180','KHĂN LEN NAM','71','2020-01-10 04:11:09','199000','2020-01-11 02:22:00',NULL,'69','92','699000',NULL,NULL,'/images/products','0','100000','Khăn len dài. Thích hợp sử dụng vào mùa đông giúp giữ ấm cơ thể.');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('181','Máy chơi game Playstation PS4 Slim 1TB Mega Pack CUH-2218B','70','2020-01-10 09:53:25','8990000','2020-01-11 02:22:00',NULL,'69',NULL,NULL,'0','1','/images/products','0','100000','Máy chơi game Playstation 4 Slim được thiết kế và sản xuất bởi hãng SONY - là 1 trong những công ty đứng đầu trên thế giới về nghiên cứu, sản xuất các thiết bị điện tử như TV, máy ảnh, Laptop,... có trụ sở tại Tokyo, Nhật Bản và được thành lập vào năm 1946 và nổi tiếng với các game thủ với các dòng máy chơi game console Playstation.     ');
INSERT INTO `auctionweb_1753102`.`product` (`Id`,`Name`,`CatId`,`StartTime`,`StartPrice`,`EndTime`,`EndPrice`,`OwnerId`,`WinnerId`,`CurrentPrice`,`IsAutoExtend`,`IsInstantBought`,`ImageFolder`,`IsRestrictBidder`,`PriceStep`,`Description`) VALUES ('182','PS3 playstation','70','2020-01-10 11:40:42','3000000','2020-01-10 12:31:10',NULL,'69','114','10500000','0','0','/images/products','0','500000','
						<p style="text-align: center;"><span style="color: #e03e2d;"><strong>This my ps3.</strong></span></p>
<p style="text-align: center;">it''s almost new...</p>
					<br>---10/1/2020, 11:41---<br><h2 style="text-align: right;"><strong>updated</strong></h2>');



/* bidderproduct */


INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','106','16699000',NULL,'2020-01-10 08:35:55','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','106','17699000',NULL,'2020-01-10 08:36:06','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','106','18699000',NULL,'2020-01-10 08:36:11','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','106','17699000',NULL,'2020-01-10 08:36:16','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','106','19699000',NULL,'2020-01-10 08:49:16','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','106','20699000',NULL,'2020-01-10 08:49:50','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','106','21699000',NULL,'2020-01-10 08:49:56','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','107','14699000',NULL,'2020-01-10 08:50:27','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','107','15699000',NULL,'2020-01-10 08:51:52','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','107','16699000',NULL,'2020-01-10 08:51:58','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','107','17699000',NULL,'2020-01-10 08:52:12','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','107','18699000',NULL,'2020-01-10 08:52:18','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','108','17699000',NULL,'2020-01-10 08:53:08','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','108','18699000',NULL,'2020-01-10 08:53:16','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','108','19699000',NULL,'2020-01-10 08:53:25','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','108','20699000',NULL,'2020-01-10 08:53:30','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','109','11699000',NULL,'2020-01-10 08:53:57','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','109','12699000',NULL,'2020-01-10 08:54:01','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','109','13699000',NULL,'2020-01-10 08:54:06','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','109','14699000',NULL,'2020-01-10 08:54:13','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','110','11699000',NULL,'2020-01-10 08:54:31','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','110','12699000',NULL,'2020-01-10 08:54:35','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','110','13699000',NULL,'2020-01-10 08:54:45','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','110','14699000',NULL,'2020-01-10 08:54:49','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','111','22699000',NULL,'2020-01-10 08:55:01','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','111','23699000',NULL,'2020-01-10 08:55:15','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','111','24699000',NULL,'2020-01-10 08:55:20','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','111','25699000',NULL,'2020-01-10 08:55:25','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','112','16699000',NULL,'2020-01-10 08:55:48','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','112','17699000',NULL,'2020-01-10 08:55:53','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','112','18699000',NULL,'2020-01-10 08:55:57','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','112','19699000',NULL,'2020-01-10 08:56:02','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','113','15449000',NULL,'2020-01-10 08:56:22','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','113','16449000',NULL,'2020-01-10 08:56:25','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','113','17449000',NULL,'2020-01-10 08:56:35','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','113','18449000',NULL,'2020-01-10 08:56:40','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','146','40099000','100499000','2020-01-10 08:57:21','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','146','40199000',NULL,'2020-01-10 08:57:32','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','146','40299000','100499000','2020-01-10 08:57:39','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','146','40399000','100499000','2020-01-10 08:57:50','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','147','40099000',NULL,'2020-01-10 08:58:02','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','147','40199000',NULL,'2020-01-10 08:58:13','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','147','40299000',NULL,'2020-01-10 08:58:21','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','147','40399000',NULL,'2020-01-10 08:58:26','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','148','34799000',NULL,'2020-01-10 08:58:38','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','148','34899000',NULL,'2020-01-10 08:58:43','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','148','34999000',NULL,'2020-01-10 08:58:55','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','148','35099000',NULL,'2020-01-10 08:59:02','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','149','3790000',NULL,'2020-01-10 08:59:19','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','149','3890000',NULL,'2020-01-10 08:59:28','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','149','3990000',NULL,'2020-01-10 08:59:32','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','149','4090000',NULL,'2020-01-10 08:59:36','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','149','4190000',NULL,'2020-01-10 08:59:41','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','150','5590000',NULL,'2020-01-10 08:59:54','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','150','5690000',NULL,'2020-01-10 08:59:58','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','150','5790000',NULL,'2020-01-10 09:00:09','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','150','5890000',NULL,'2020-01-10 09:00:13','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','151','5190000',NULL,'2020-01-10 09:00:32','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','151','5290000',NULL,'2020-01-10 09:00:41','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','151','5390000',NULL,'2020-01-10 09:00:46','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','151','5490000',NULL,'2020-01-10 09:00:50','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','152','5790000',NULL,'2020-01-10 09:01:14','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','152','5890000',NULL,'2020-01-10 09:01:18','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','152','5990000',NULL,'2020-01-10 09:01:22','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','152','6090000',NULL,'2020-01-10 09:01:26','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','153','4190000',NULL,'2020-01-10 09:01:35','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','153','4290000',NULL,'2020-01-10 09:01:46','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','153','4390000',NULL,'2020-01-10 09:01:49','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','153','4490000',NULL,'2020-01-10 09:01:53','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','154','4099000',NULL,'2020-01-10 09:02:08','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','154','4199000','10499000','2020-01-10 09:02:17','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','154','4299000',NULL,'2020-01-10 09:02:22','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','154','4399000','10499000','2020-01-10 09:02:27','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','154','4499000','10499000','2020-01-10 09:13:08','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','154','4599000',NULL,'2020-01-10 09:15:13','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','154','4699000','10499000','2020-01-10 09:15:14','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','115','19699000','30699000','2020-01-10 09:15:46','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','115','20699000',NULL,'2020-01-10 09:16:12','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','115','21699000','30699000','2020-01-10 09:16:12','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','115','22699000',NULL,'2020-01-10 09:16:24','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','115','23699000','30699000','2020-01-10 09:16:24','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','155','4699000','14699000','2020-01-10 09:17:39','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','155','4799000',NULL,'2020-01-10 09:18:11','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','155','4899000','14699000','2020-01-10 09:18:11','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','155','50999000',NULL,'2020-01-10 09:18:41','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','158','399000',NULL,'2020-01-10 09:26:29','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','158','499000',NULL,'2020-01-10 09:26:34','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','158','599000',NULL,'2020-01-10 09:26:38','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','158','699000',NULL,'2020-01-10 09:26:43','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','159','1320000',NULL,'2020-01-10 09:26:52','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','159','1420000',NULL,'2020-01-10 09:27:02','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','159','1520000',NULL,'2020-01-10 09:27:08','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','159','1620000',NULL,'2020-01-10 09:27:12','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','160','1320000',NULL,'2020-01-10 09:27:21','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','160','1420000',NULL,'2020-01-10 09:27:25','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','160','1520000',NULL,'2020-01-10 09:27:39','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','160','1620000',NULL,'2020-01-10 09:27:43','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','161','249000',NULL,'2020-01-10 09:27:59','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','161','349000',NULL,'2020-01-10 09:28:10','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','161','449000',NULL,'2020-01-10 09:28:14','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','161','549000',NULL,'2020-01-10 09:28:18','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','162','1890000',NULL,'2020-01-10 09:28:45','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','162','1990000',NULL,'2020-01-10 09:28:48','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','162','2090000',NULL,'2020-01-10 09:28:55','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','162','2190000',NULL,'2020-01-10 09:29:01','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','174','599000',NULL,'2020-01-10 09:30:27','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','174','699000',NULL,'2020-01-10 09:30:31','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','174','799000',NULL,'2020-01-10 09:30:37','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','174','899000',NULL,'2020-01-10 09:30:42','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','175','549000',NULL,'2020-01-10 09:31:10','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','175','649000',NULL,'2020-01-10 09:31:14','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','175','749000',NULL,'2020-01-10 09:31:18','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','175','849000',NULL,'2020-01-10 09:31:26','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','175','949000',NULL,'2020-01-10 09:31:30','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','176','799000',NULL,'2020-01-10 09:31:45','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','176','899000',NULL,'2020-01-10 09:31:49','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','176','999000',NULL,'2020-01-10 09:31:53','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','176','1099000',NULL,'2020-01-10 09:31:57','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','176','1199000',NULL,'2020-01-10 09:32:14','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','177','399000',NULL,'2020-01-10 09:32:29','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','177','499000',NULL,'2020-01-10 09:32:37','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','177','599000',NULL,'2020-01-10 09:32:41','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','177','699000',NULL,'2020-01-10 09:32:45','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','178','549000',NULL,'2020-01-10 09:32:54','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','178','649000',NULL,'2020-01-10 09:33:03','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','178','749000',NULL,'2020-01-10 09:33:11','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','178','849000',NULL,'2020-01-10 09:33:18','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','179','549000',NULL,'2020-01-10 09:33:26','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','179','649000',NULL,'2020-01-10 09:33:35','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','179','749000',NULL,'2020-01-10 09:33:39','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','179','849000',NULL,'2020-01-10 09:33:43','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','180','299000',NULL,'2020-01-10 09:33:57','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','180','399000',NULL,'2020-01-10 09:34:06','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','180','499000',NULL,'2020-01-10 09:34:10','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','180','599000',NULL,'2020-01-10 09:34:14','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','180','699000',NULL,'2020-01-10 09:34:19','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','163','338000',NULL,'2020-01-10 09:38:03','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','163','438000',NULL,'2020-01-10 09:38:08','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','163','538000',NULL,'2020-01-10 09:38:16','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','163','638000',NULL,'2020-01-10 09:38:21','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','163','738000',NULL,'2020-01-10 09:38:26','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','164','112000',NULL,'2020-01-10 09:38:58','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','164','212000',NULL,'2020-01-10 09:39:03','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','164','312000',NULL,'2020-01-10 09:39:08','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','164','412000',NULL,'2020-01-10 09:39:13','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','165','119000',NULL,'2020-01-10 09:39:37','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','165','219000',NULL,'2020-01-10 09:39:45','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','165','319000',NULL,'2020-01-10 09:39:49','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','165','419000',NULL,'2020-01-10 09:39:54','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','166','185000',NULL,'2020-01-10 09:40:11','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','166','285000',NULL,'2020-01-10 09:40:15','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','166','385000',NULL,'2020-01-10 09:40:19','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','166','485000',NULL,'2020-01-10 09:40:24','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','167','117100',NULL,'2020-01-10 09:40:32','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','167','217100',NULL,'2020-01-10 09:40:37','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','167','317100',NULL,'2020-01-10 09:40:55','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','167','417100',NULL,'2020-01-10 09:41:16','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','167','517100',NULL,'2020-01-10 09:41:20','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','168','225000',NULL,'2020-01-10 09:41:33','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','168','325000',NULL,'2020-01-10 09:41:38','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','168','425000',NULL,'2020-01-10 09:41:47','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','168','525000',NULL,'2020-01-10 09:41:51','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','168','625000',NULL,'2020-01-10 09:42:01','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','168','625000',NULL,'2020-01-10 09:42:13','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','168','725000',NULL,'2020-01-10 09:42:34','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','168','725000',NULL,'2020-01-10 09:42:40','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','168','825000',NULL,'2020-01-10 09:43:11','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','169','3990000',NULL,'2020-01-10 09:43:46','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','169','4090000',NULL,'2020-01-10 09:43:52','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','169','3990000',NULL,'2020-01-10 09:43:59','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','169','4190000',NULL,'2020-01-10 09:44:37','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','170','20690000',NULL,'2020-01-10 09:44:47','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','170','20790000',NULL,'2020-01-10 09:44:53','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','170','20890000',NULL,'2020-01-10 09:45:10','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','170','30990000',NULL,'2020-01-10 09:45:23','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','171','279000',NULL,'2020-01-10 09:45:48','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','171','379000',NULL,'2020-01-10 09:45:53','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','171','479000',NULL,'2020-01-10 09:45:59','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','171','579000',NULL,'2020-01-10 09:46:03','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','171','679000',NULL,'2020-01-10 09:46:10','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('116','111','26699000',NULL,'2020-01-10 11:16:34','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('116','182','3500000',NULL,'2020-01-10 12:12:10','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('116','182','4000000',NULL,'2020-01-10 12:16:37','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','182','4500000','40000000','2020-01-10 12:27:22','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('116','182','5000000',NULL,'2020-01-10 12:27:45','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','182','5500000','40000000','2020-01-10 12:27:45','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('116','182','10000000',NULL,'2020-01-10 12:28:04','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','182','10500000','40000000','2020-01-10 12:28:04','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('116','109','15699000',NULL,'2020-01-10 14:48:49','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','146','40499000','100499000','2020-01-10 16:13:33','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','146','40599000',NULL,'2020-01-10 16:16:14','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','146','40699000','100499000','2020-01-10 16:16:14','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('92','146','90799000',NULL,'2020-01-10 16:16:32','0','0');
INSERT INTO `auctionweb_1753102`.`bidderproduct` (`BidderId`,`ProId`,`Price`,`AutoMaxPrice`,`DateCreate`,`IsWin`,`IsBanned`) VALUES ('114','146','90899000','100499000','2020-01-10 16:16:32','0','0');


/* commmentrate */


INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('66','92','114','1','You are good','2010-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('67','105','114','-1',' #@$@^%#','2011-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('68','106','114','1','You are good','2012-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('69','108','114','1','You are good','2020-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('70','110','114','-1','you suck!','2020-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('71','114','92','-1','damn bad','2020-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('72','111','92','-1','really bad guy','2020-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('73','113','92','1','You are good','2020-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('74','110','92','-1','nothing to say, good bye','2020-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('75','112','92','1',' You are well-done','2020-01-06 22:08:25','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('76','112','114','1',' You are well-done (updated)','2020-01-06 22:11:38','0');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('77','114','92','1','ok...','2020-01-08 08:18:13','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('78','114','92','-1','Winner does not pay','2020-01-08 08:33:13','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('79','114','92','-1','Winner does not pay','2020-01-08 08:34:07','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('80','114','92','-1','Winner does not pay','2020-01-08 08:35:00','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('81','114','92','-1','Winner does not pay','2020-01-08 08:36:52','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('82','114','92','-1','Winner does not pay','2020-01-08 08:37:14','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('83','114','92','-1','Winner does not pay','2020-01-08 08:38:14','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('84','114','92','-1','Winner does not pay','2020-01-08 09:02:12','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('85','114','92','1','frergfreg','2020-01-08 09:14:59','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('86','114','92','-1','sfs234567','2020-01-08 09:20:09','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('87','114','92','-1','Winner does not pay','2020-01-08 09:20:20','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('88','114','92','-1','Winner does not pay','2020-01-08 09:21:16','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('89','114','92','-1','Winner does not pay','2020-01-08 09:24:57','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('90','114','92','-1','Winner does not pay','2020-01-08 09:26:56','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('91','114','92','-1','Winner does not pay','2020-01-08 09:29:07','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('92','114','92','-1','Winner does not pay','2020-01-08 09:29:45','135');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('93','114','92','1','sdvsvsdv','2020-01-08 09:32:40','134');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('94','114','92','-1','Winner does not pay','2020-01-08 09:35:01','134');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('95','114','92','-1','Winner does not pay','2020-01-08 09:35:01','140');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('96','114','92','-1','Winner does not pay','2020-01-10 00:07:08','136');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('97','114','92','1','','2020-01-10 00:08:27','117');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('98','114','92','1','ngon quá ta','2020-01-10 00:09:00','117');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('99','92','69','1','','2020-01-10 00:15:53','114');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('100','92','69','1','sản phẩm rất ưng ý ;))','2020-01-10 11:21:17','155');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('101','69','92','-1','ngon quá ta','2020-01-10 11:44:32','155');
INSERT INTO `auctionweb_1753102`.`commentrate` (`Id`,`FromId`,`ToId`,`Point`,`Message`,`DateCreate`,`ProId`) VALUES ('102','116','69','1','ban duoc day','2020-01-10 14:50:46','182');

/* upgraderequest */


/* watchlist */

INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','109');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','109');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','115');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','106');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','109');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','111');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','112');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','113');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','114');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','115');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','116');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','117');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','107');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','107');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('114','144');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','107');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','106');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','108');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','110');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','109');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','111');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','146');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','113');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','112');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','155');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('92','158');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('116','115');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('116','106');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('116','107');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('116','110');
INSERT INTO `auctionweb_1753102`.`watchlist` (`AccountId`,`ProId`) VALUES ('116','111');

/* end */
