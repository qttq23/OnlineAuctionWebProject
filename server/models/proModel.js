
const db = require('../utils/db');
const moment = require('moment');
moment.locale('vi');

const table = 'product';

module.exports = {

	all: ()=>{ 
		return db.load(table)
	},

	// nested query
	some: (catId, numPro, offset)=>{
		
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, b.Turn, b.Price as Max_Price, b.BidderId
		from (select *
		from product as p
		where p.CatId = '${catId}'
		limit ${numPro} offset ${offset}
		) as sortedPro
		left join
		(
		select tt1.*, tt2.Turn 
		FROM (
		SELECT *
		from bidderproduct b3
		where b3.Price >= all(
		select b1.Price 
		from bidderproduct as b1 
		where b1.ProId = b3.ProId and b1.IsBanned = 0) and b3.IsBanned = 0

		group by b3.ProId
		) as tt1,
		(
		select  b2.ProId, count(b2.BidderId) as Turn
		from bidderproduct b2
		where b2.IsBanned = 0
		GROUP by b2.ProId
		) as tt2
		where tt1.ProId = tt2.ProId
		) as b
		on sortedPro.Id = b.ProId and b.isBanned = 0
		) as t2
		left join
		account as bidder on t2.BidderId = bidder.Id
		left join 
		account as owner on t2.OwnerId = owner.Id

		
		`;
		return db.query(sql);

	},

	// nested query
	single: async (id)=>{
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, b.Turn, b.Price as Max_Price, b.BidderId
		from (select *
		from product
		where Id = ${id}
		) as sortedPro
		left join
		(
		select tt1.*, tt2.Turn 
		FROM (
		SELECT *
		from bidderproduct b3
		where b3.Price >= all(
		select b1.Price 
		from bidderproduct as b1 
		where b1.ProId = b3.ProId and b1.IsBanned = 0) and b3.IsBanned = 0

		group by b3.ProId
		) as tt1,
		(
		select  b2.ProId, count(b2.BidderId) as Turn
		from bidderproduct b2
		where b2.IsBanned = 0
		GROUP by b2.ProId
		) as tt2
		where tt1.ProId = tt2.ProId
		) as b
		on sortedPro.Id = b.ProId and b.isBanned = 0
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


	// nested query
	nearEnd: (numPro)=>{
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, b.Turn, b.Price as Max_Price, b.BidderId
		from (select *
		from product as p
		where TIMESTAMPDIFF(SECOND,p.EndTime,CURRENT_TIMESTAMP()) < 0
		order by p.EndTime ASC
		limit ${numPro} offset 0) as sortedPro
		left join
		(
		select tt1.*, tt2.Turn 
		FROM (
		SELECT *
		from bidderproduct b3
		where b3.Price >= all(
		select b1.Price 
		from bidderproduct as b1 
		where b1.ProId = b3.ProId and b1.isBanned=0) and b3.isBanned = 0

		group by b3.ProId
		) as tt1,
		(
		select  b2.ProId, count(b2.BidderId) as Turn
		from bidderproduct b2 
		where b2.isBanned = 0
		GROUP by b2.ProId
		) as tt2
		where tt1.ProId = tt2.ProId
		) as b
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

	// nested query
	mostTurn: (numPro)=>{
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select p.*, b.Turn, b.Price as Max_Price, b.BidderId
		from (
		select tt1.*, tt2.Turn 
		FROM (
		SELECT *
		from bidderproduct b3
		where b3.Price >= all(
		select b1.Price 
		from bidderproduct as b1 
		where b1.ProId = b3.ProId and b1.isBanned = 0) and b3.isBanned = 0

		group by b3.ProId
		) as tt1,
		(
		select  b2.ProId, count(b2.BidderId) as Turn
		from bidderproduct b2 
		where b2.isBanned = 0
		GROUP by b2.ProId
		) as tt2
		where tt1.ProId = tt2.ProId
		order by tt2.Turn desc
		limit ${numPro} offset 0
		) as b,
		product as p
		where b.ProId = p.Id) as t2,
		account as bidder,
		account as owner

		where t2.BidderId = bidder.Id and t2.OwnerId = owner.Id
		order by t2.Turn desc
		`;

		return db.query(sql);
	},

	// nested query
	highestPrice: (numPro)=>{

		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select p.*, b.Turn, b.Price as Max_Price, b.BidderId
		from (
		select tt1.*, tt2.Turn 
		FROM (
		SELECT *
		from bidderproduct b3
		where b3.Price >= all(
		select b1.Price 
		from bidderproduct as b1 
		where b1.ProId = b3.ProId and b1.isBanned = 0) and b3.isBanned = 0

		group by b3.ProId
		) as tt1,
		(
		select  b2.ProId, count(b2.BidderId) as Turn
		from bidderproduct b2 
		where b2.isBanned = 0
		GROUP by b2.ProId
		) as tt2
		where tt1.ProId = tt2.ProId
		
		) as b,
		product as p
		where b.ProId = p.Id and TIMESTAMPDIFF(SECOND,p.EndTime,CURRENT_TIMESTAMP()) < 0
		order by b.Price desc
		limit ${numPro} offset 0) as t2,
		account as bidder,
		account as owner
		where t2.BidderId = bidder.Id and t2.OwnerId = owner.Id
		order by t2.Max_Price desc
		`;

		return db.query(sql);
	},

	// nested query
	search: async (type, keyword, numPro, offset)=>{
		
		let results = null;
		if(type === 'Name'){
			// by product name
			// results = await db.fullTextSearch(table, [type], keyword);

			let sql = `
			select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
			from (select sortedPro.*, b.Turn, b.Price as Max_Price, b.BidderId
			from (select *
			from product
			where match (Name) against ('$${keyword}*' in boolean mode) > 0
			) as sortedPro
			left join
			(
			select tt1.*, tt2.Turn 
			FROM (
			SELECT *
			from bidderproduct b3
			where b3.Price >= all(
			select b1.Price 
			from bidderproduct as b1 
			where b1.ProId = b3.ProId and b1.isBanned = 0) and b3.isBanned = 0

			group by b3.ProId
			) as tt1,
			(
			select  b2.ProId, count(b2.BidderId) as Turn
			from bidderproduct b2 where b2.isBanned = 0
			GROUP by b2.ProId
			) as tt2
			where tt1.ProId = tt2.ProId
			) as b
			on sortedPro.Id = b.ProId and b.isBanned = 0
			
			) as t2
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
				let catId = list[0].Id;
				let sql = `
				select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
				from (select sortedPro.*, b.Turn, b.Price as Max_Price, b.BidderId
				from (select *
				from product
				where CatId = ${catId}
				) as sortedPro
				left join
				(
				select tt1.*, tt2.Turn 
				FROM (
				SELECT *
				from bidderproduct b3
				where b3.Price >= all(
				select b1.Price 
				from bidderproduct as b1 
				where b1.ProId = b3.ProId and b1.isBanned = 0) and b3.isBanned = 0

				group by b3.ProId
				) as tt1,
				(
				select  b2.ProId, count(b2.BidderId) as Turn
				from bidderproduct b2 where b2.isBanned = 0
				GROUP by b2.ProId
				) as tt2
				where tt1.ProId = tt2.ProId
				) as b
				on sortedPro.Id = b.ProId and b.isBanned = 0) as t2
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

		// check if price of bidder is valid
		let newPrice = +pro.Max_Price + +pro.PriceStep;
		if(price < newPrice){
			return {isOk: false, msg: "Your price is less than the valid price."};
		}

		// check if user is banned
		//...
		let sql = `
		select * 
		from bidderproduct
		where ProId = ${pro.Id} and BidderId = ${userId} and isbanned = 1
		`;
		const results = await db.query(sql);
		if(results != null && results.length > 0){
			// this mean user is banned from this product
			// fail to bid
			return {isOk: false, msg: "You are banned from this product."};
		}

		// check if product still available
		let a = moment();
		let b = moment(pro.EndTime);
		let diff = b.diff(a, 'seconds');
		lg(diff);
		
		if(diff > 0){
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

	getHistory: async(proId)=>{

		// get all product id in table 'bidderproduct': bidder id, bidder name, dateCreate, not banned
		let sql = `
		select b1.*, a1.Name as BidderName
		FROM bidderproduct as b1,
		account as a1
		where b1.ProId = ${proId} and b1.isBanned = 0 and b1.BidderId = a1.Id
		order by b1.DateCreate asc
		`;

		const results = await db.query(sql);
		if(results != null && results.length > 0){
			return {isOk: true, history: results};
		}

		return null;
	},

	add: async (product)=>{
		// check instantBuy price >= startPrice
		let p1 = +product.EndPrice;
		let p2 = +product.StartPrice + +product.PriceStep;
		if(p1 < p2){
			return {isOk: false, msg: "The win price mustn't be less than total of start price and step price."};
		}

		// check end time > current time
		let a = moment();
		let b = moment(product.EndTime);
		let diff = b.diff(a, 'seconds');
		// lg(diff);
		if(diff <= 0){
			return {isOk: false, msg: "The end time mustn't be less than the current time."};
		}

		// all ok
		const result = await db.save(table, product);
		lg(result);
		if(result.affectedRows >= 1){
			return {
				isOk: true,
				msg: "Upload product successfully.",
				insertId: result.insertId
			};
		}

		return {isOk: false, msg: "Upload product failed."};

	}

}


