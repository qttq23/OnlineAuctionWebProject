
const db = require('../utils/db');
const table = 'product';

module.exports = {

	all: ()=>{ 
		return db.load(table)
	},

	some: (catId, numPro, offset)=>{
		// return db.query(`
		// 	select * from product
		// 	where CatId = '${catId}'
		// 	limit ${numPro} offset ${offset}`);


		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, count(b.BidderId) as Turn, MAX(b.Price) as Max_Price, b.BidderId
		from (select *
		from product as p
		where p.CatId = '${catId}'
		limit ${numPro} offset ${offset}) as sortedPro
		left join
		bidderproduct as b
		on sortedPro.Id = b.ProId and b.isBanned = 0
		group by sortedPro.Id) as t2
		left join
		account as bidder on t2.BidderId = bidder.Id
		left join 
		account as owner on t2.OwnerId = owner.Id

		
		`;
		return db.query(sql);

	},



	nearEnd: (numPro)=>{
		let sql = `
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
		`;

		return db.query(sql);
	},

	mostTurn: (numPro)=>{
		let sql = `
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
		`;

		return db.query(sql);
	},

	highestPrice: (numPro)=>{
		let sql = `
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
		`;

		return db.query(sql);
	}
}


