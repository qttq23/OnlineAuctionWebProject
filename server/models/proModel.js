
const db = require('../utils/db');
const moment = require('moment');

const table = 'product';

module.exports = {

	all: ()=>{ 
		return db.load(table)
	},

	some: (catId, numPro, offset)=>{
		
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

	single: async (id)=>{
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, count(b.BidderId) as Turn, MAX(b.Price) as Max_Price, b.BidderId
		from (select *
		from product as p
		where p.Id = ${id}) as sortedPro
		left join
		bidderproduct as b
		on sortedPro.Id = b.ProId and b.isBanned = 0
		
		where b.Price >= all(
		select b1.Price 
		from bidderproduct as b1 
		where b1.ProId = sortedPro.Id)
		) as t2
		left join
		account as bidder on t2.BidderId = bidder.Id
		left join 
		account as owner on t2.OwnerId = owner.Id

		
		`;

		const results = await db.query(sql);
		if(results != null && results.length > 0){
			return results[0];
		}

		return null;
	},



	nearEnd: (numPro)=>{
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, count(b.BidderId) as Turn, MAX(b.Price) as Max_Price, b.BidderId
		from (select *
		from product as p
		where TIMESTAMPDIFF(SECOND,p.EndTime,CURRENT_TIMESTAMP()) < 0
		order by p.EndTime ASC
		limit 5 offset 0) as sortedPro
		left join
		bidderproduct as b
		on sortedPro.Id = b.ProId and b.isBanned = 0
		group by sortedPro.Id) as t2
		left join
		account as bidder on t2.BidderId = bidder.Id
		left join 
		account as owner on t2.OwnerId = owner.Id

		order by t2.EndTime ASC
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
		) as popularPro,
		product as p
		where popularPro.ProId = p.Id and TIMESTAMPDIFF(SECOND,p.EndTime,CURRENT_TIMESTAMP()) < 0
		limit 5 offset 0) as t2,
		account as bidder,
		account as owner
		where t2.BidderId = bidder.Id and t2.OwnerId = owner.Id
		order by t2.Max_Price desc
		`;

		return db.query(sql);
	},

	search: async (type, keyword, numPro, offset)=>{
		
		let results = null;
		if(type === 'Name'){
			// by product name
			// results = await db.fullTextSearch(table, [type], keyword);

			let sql = `
			select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
			from (select sortedPro.*, count(b.BidderId) as Turn, MAX(b.Price) as Max_Price, b.BidderId
			from (select *
			from product
			where match (Name) against ('$${keyword}*' in boolean mode) > 0
			) as sortedPro
			left join
			bidderproduct as b
			on sortedPro.Id = b.ProId and b.isBanned = 0
			group by sortedPro.Id) as t2
			left join
			account as bidder on t2.BidderId = bidder.Id
			left join 
			account as owner on t2.OwnerId = owner.Id


			`;
			results = await db.query(sql);

			// search ok
			if(results != null && results.length > 0){

				// refine output
				let list =[];
				let count = 0;
				for(let i = offset; i < results.length; i++){
					if(count < numPro){

						list.push(results[i]);
						count++;
					}
					else{
						break;
					}
				}

				return {
					total: results.length,
					list: list,
				};
			}

			//search fails
			return {
				total: 0,
				list: [],
			};
		}
		else{
			// by catagory
			results = await db.fullTextSearch('catagory', ['Name'], keyword);

			// search ok
			if(results != null && results.length > 0){
				lg(results);

				// get 2 most related catagories
				let list = results;

				// select products for related catagories

				let sql = `
				select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
				from (select sortedPro.*, count(b.BidderId) as Turn, MAX(b.Price) as Max_Price, b.BidderId
				from (select *
				from product as p
				where p.CatId = '${list[0].Id}'
				) as sortedPro
				left join
				bidderproduct as b
				on sortedPro.Id = b.ProId and b.isBanned = 0
				group by sortedPro.Id) as t2
				left join
				account as bidder on t2.BidderId = bidder.Id
				left join 
				account as owner on t2.OwnerId = owner.Id


				`;
				results = await db.query(sql);

				if(results != null && results.length > 0){

					// search ook
					list = [];
					count = 0;
					for(let i = offset; i < results.length; i++){
						if(count < numPro){
							list.push(results[i]);
							count++;
						}
						else{
							break;
						}
					}

					return {
						total: results.length,
						list: list,
					};
				}

				//search fails
				return {
					total: 0,
					list: [],
				};
			}

			//search fails
			return {
				total: 0,
				list: [],
			};
		}




	},

	getPrice: async (userId, pro)=>{

		lg(pro.Max_Price);
		lg(pro.PriceStep);

		// check if product require point to bid
		if(pro.IsRestrictBidder === '1'){

			// check the bidder's point
			const result = await db.query(
				`select count(*) as count 
				from commentrate 
				where ToId=${userId}`);
			let total = +result[0].count;

			if(total > 0){

				let likes = await db.query(
					`select count(*) as count 
					from commentrate 
					where ToId=${userId} and Point=1`);
				likes = +likes[0].count;

				if((likes/total * 100) > 80){
					// allowed
					// calc price
					let newPrice = +pro.Max_Price + +pro.PriceStep;
					return {isOk: true, newPrice: newPrice};

				}
				else{
					// --> not allowed to bid
					return {isOk: false, msg: "Your point is less than 80% to bid this product."};
				}
			}
			else{
				// not any point
				// --> not allowed to bid
				return {isOk: false, msg: "Only rated user can bid this product."};
			}
		}
		else{
			// no restrict
			// allowed
			// calc price
			let newPrice = +pro.Max_Price + +pro.PriceStep;
			return {isOk: true, newPrice: newPrice};
		}
	},

	setBid: async(userId, pro, price)=>{

		// check if product still available
		// let a = moment();
		// let b = moment(pro.EndTime);
		// let diff = b.diff(a, 'seconds');
		// lg(diff);
		if(true){
			// still available
			// bid success
			// update table
			let record = {
				BidderId: userId,
				ProId: pro.Id,
				Price: price
			};
			const result = await db.save('bidderproduct', record);
			return {isOk: true, msg: "Bid success."};
		}
		else{
			// out of time
			// bid fail
			return {isOk: false, msg: "Product is not available any more."};
		}
	},
}


