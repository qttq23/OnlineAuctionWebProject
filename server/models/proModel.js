
const db = require('../utils/db');
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
		group by sortedPro.Id) as t2
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




	}
}


