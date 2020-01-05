----
alter table book add fulltext (title);

SELECT book.*, MATCH (title) AGAINST ('$life of Pi*' IN BOOLEAN MODE) as score
FROM book 
WHERE MATCH (title) AGAINST ('$life of Pi*' IN BOOLEAN MODE) > 0 
ORDER BY score DESC;
----


-- create database
drop database AuctionWeb_1753102;
create database AuctionWeb_1753102;
use AuctionWeb_1753102;

-- create tables


-- catagory
drop table Catagory;
CREATE TABLE Catagory (
  Id int(11) NOT NULL AUTO_INCREMENT,
  Name text not null,
  NumPro int(11) default 0,
  DateCreate datetime DEFAULT CURRENT_TIMESTAMP,
  
  PRIMARY KEY (Id)

) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- product

drop table Product;
CREATE TABLE Product (
  Id int(11) NOT NULL AUTO_INCREMENT,
  Name text not null,
  CatId int(11) not null,
  StartTime datetime default CURRENT_TIMESTAMP,
  StartPrice int(11) not null,
  EndTime datetime not null,
  EndPrice int(11),
  OwnerId int(11) not null,
  WinnerId int(11),
  CurrentPrice int(11),
  IsAutoExtend int(11) default 0,
  IsInstantBought int(11) default 0,
  ImageFolder text,
  IsRestrictBidder int(11) default 1,
  PriceStep int(11) not null,
  Description text,
  
  PRIMARY KEY (Id),
  FOREIGN key (CatId) references Catagory(Id),
  FOREIGN key (OwnerId) references Account(Id),
  FOREIGN key (WinnerId) references Account(Id)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- bidderProduct
drop table BidderProduct;
 create table BidderProduct(
	BidderId int(11) not null,
	ProId int(11) not null,
	Price int(11) not null,
	MaxPrice int(11),
	DateCreate datetime default CURRENT_TIMESTAMP,
	IsWin int(11) default 0,
	IsBanned int(11) default 0,
	
	FOREIGN KEY (BidderId) REFERENCES Account(Id),
	FOREIGN KEY (ProId) REFERENCES Product(Id)
)ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

-- account
drop table Account;
create table Account(
	Id int(11) auto_increment not null,
	Username text not null,
	Password text not null,
	AccType int(11) default 0,
	Point int(11),
	
	Name text not null,
	Address text,
	Birthday date,
	Email text not null,
	
	primary key (Id)
	
)ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
alter table account convert to character set utf8mb4 collate utf8mb4_bin





-- accountSession
drop table AccountSession;
CREATE TABLE AccountSession (
  Id text NOT NULL,
  AccountId int(11) not null,
  DateCreate datetime default CURRENT_TIMESTAMP,
  
  PRIMARY KEY (Id(100)),
  FOREIGN KEY (AccountId) REFERENCES Account(Id)

) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- watchList
drop table WatchList;
CREATE TABLE WatchList (
  AccountId int(11) NOT NULL,
  ProId int(11) not null,

  FOREIGN KEY (AccountId) REFERENCES Account(Id),
  FOREIGN KEY (ProId) REFERENCES Product(Id)

) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- commentRate
drop table CommentRate;
CREATE TABLE CommentRate (
  FromId int(11) not null,
  ToId int(11) not null,
  Point int(11) not null,
  Message text not null,
  DateCreate datetime default CURRENT_TIMESTAMP,
 
  FOREIGN KEY (FromId) REFERENCES Account(Id),
  FOREIGN KEY (ToId) REFERENCES Account(Id)
  
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci



-- upgradeRequest
drop table UpgradeRequest;
CREATE TABLE UpgradeRequest (
  FromId int(11) not null,
  DateCreate datetime default CURRENT_TIMESTAMP,
 
  FOREIGN KEY (FromId) REFERENCES Account(Id)

  
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci




-- bannedBidder
drop table BannedBidder;
CREATE TABLE BannedBidder (

  BidderId int(11) not null,
  ProId int(11) not null,
 
  FOREIGN KEY (BidderId) REFERENCES Account(Id),
  FOREIGN KEY (ProId) REFERENCES Product(Id)
  
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci



---- query
SELECT p.Id, P.Name, a.Id as accId, a.Name as accName
FROM product as p, bidderproduct as b, account as a
WHERE p.Id = b.ProId and p.Id = 87 and a.Id = b.BidderId


-- sort product descend datetime
select *
from product as p
order by p.EndTime DESC

-- join product vs bidderproduct and get highest price
select sortedPro.Id, MAX(b.Price) as Max_Price, b.BidderId
from (select *
	from product as p
	order by p.EndTime DESC
	limit 2 offset 0) as sortedPro, 
	bidderproduct as b
where sortedPro.Id = b.ProId and b.isBanned = 0
group by sortedPro.Id


-- get user info
-- 5 nearly ended products
select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
from (select sortedPro.*, count(b.BidderId) as Turn, MAX(b.Price) as Max_Price, b.BidderId
	from (select *
		from product as p
		order by p.EndTime DESC
		limit 5 offset 0) as sortedPro
		left join
		bidderproduct as b
		on sortedPro.Id = b.ProId and b.isBanned = 0
		group by sortedPro.Id) as t2
	left join
	account as bidder on t2.BidderId = bidder.Id
	left join 
	account as owner on t2.OwnerId = owner.Id
order by t2.EndTime DESC



-- 5 most bid-turn products
select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
from (select p.*, popularPro.Turn, popularPro.Max_Price, popularPro.BidderId
		from (select ProId, count(BidderId) as Turn, MAX(Price) as Max_Price, BidderId
			from bidderproduct
			where IsBanned = 0
			group by ProId
			order by count(BidderId)
			limit 5 offset 0) as popularPro,
		product as p
		where popularPro.ProId = p.Id) as t2,
	account as bidder,
	account as owner
	
where t2.BidderId = bidder.Id and t2.OwnerId = owner.Id
order by t2.Turn desc
---



-- 5 highest price products
select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
from (select p.*, popularPro.Turn, popularPro.Max_Price, popularPro.BidderId
		from (select ProId, count(BidderId) as Turn, MAX(Price) as Max_Price, BidderId
			from bidderproduct
			where IsBanned = 0
			group by ProId
			order by max(Price) desc
			limit 5 offset 0) as popularPro,
		product as p
		where popularPro.ProId = p.Id) as t2,
	account as bidder,
	account as owner
	
where t2.BidderId = bidder.Id and t2.OwnerId = owner.Id
order by t2.Max_Price desc


select * from account limit 5 offset 5
select * from account where Id = '93' limit 5 offset 0

select count(*) from account
select count(*) ffrom

/* full text search*/

ALTER TABLE product ADD FULLTEXT (Name);
ALTER TABLE catagory ADD FULLTEXT (Name);

select product.*, match (Name) against ('$ef*' in boolean mode) as score
			from product
			where match (Name) against ('$ef*' in boolean mode) > 0
			order by score 
			limit 1 offset 0
			
select product.*
			from product
			where match (Name) against ('$ef*' in boolean mode) > 0
	
			limit 1 offset 0
			
			
			


