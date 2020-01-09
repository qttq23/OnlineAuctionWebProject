
const db = require('../utils/db');
const moment = require('moment');
moment.locale('vi');

const table = 'product';

async function resolveBidders(listBidders, validPrice){
	// input: list of auto bidders
	// output: who win at the present, and bid a price to bidderproduct table

	lg('resolveBidders');

	let enoughPrice = validPrice;
	if(listBidders.length === 1){
		
		// do nothing
		lg('donothing');
	}
	else if(listBidders.length >= 2){

		// sort descending
		for(let i = 0; i < 2; i++){
			for(let j = i + 1; j < listBidders.length; j++){
				if(listBidders[i].AutoMaxPrice < listBidders[j].AutoMaxPrice){
					//swap
					let temp = listBidders[i];
					listBidders[i] = listBidders[j];
					listBidders[j] = temp;
				}
			}
		}
		lg('after sort');
		lg(listBidders);

		// bid price
		enoughPrice = listBidders[1].AutoMaxPrice + 1;


	}


	// save bid price for this bidder
	let record = {
		BidderId: listBidders[0].BidderId,
		ProId: listBidders[0].ProId,
		Price: enoughPrice,
		AutoMaxPrice: listBidders[0].AutoMaxPrice
	};
	const result = await db.save('bidderproduct', record);
	lg('save new bid');

	// highest price event
	highestPriceEvent(listBidders[0].BidderId);

}

async function highestPriceEvent(bidder){
	if(!bidder){
		//... query by myself
		// bidder = ...
	}
	return lg('The highest price bidder at the moment is : ' + bidder);
}




var self = module.exports = {

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
		if(pro.Max_Price === ''){
			pro.Max_Price = pro.StartPrice;
		}

		// check if product is already win
		let prod = await db.query(`
			select *
			from product p 
			where p.Id = ${pro.Id}
			`);
		if(prod.length > 0 && prod[0].WinnerId > 0 && prod[0].CurrentPrice > 0){
			// this mean product is already win and emails already sent
			// no need to send email any more
			// no need to bid any more
			return {isOk: false, msg: "The product was already finished. Can't bid any more."};
		}

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
			lg('product available');



			// get the current highest bidder
			let bidder = await self.getHighestBidder(userId, pro.Id);
			let bidderx = bidder;

			// if same price
			let isBidAdvance = false;
			if(bidder && +bidder.AutoMaxPrice === +price){
				lg('same price');

				// the current will bid first
				let record = {
					BidderId: bidder.BidderId,
					ProId: pro.Id,
					Price: price,
					AutoMaxPrice: bidder.AutoMaxPrice
				};
				await db.save('bidderproduct', record);
				isBidAdvance = true;
			}

			// bid for new bidder
			// update table
			let record = {
				BidderId: userId,
				ProId: pro.Id,
				Price: price,
				AutoMaxPrice: pro.AutoMaxPrice
			};
			const result = await db.save('bidderproduct', record);
			lg('ok1');
			if(pro.AutoMaxPrice != null){

				await db.query(
					`update bidderproduct 
					set AutoMaxPrice=${pro.AutoMaxPrice} 
					where BidderId=${userId} and ProId=${pro.Id}`);
			}
			lg('saved new bid');

			// resolve auto bidders
			if(bidder && bidder.AutoMaxPrice > price){
				lg('current highest bidder is auto');

				// save bid price for this bidder
				let enoughPrice = +price + +pro.PriceStep;
				if(bidder.AutoMaxPrice >= enoughPrice){
					
					lg('current highest bidder is able to bid');

					// check if new bidder is auto
					if(pro.AutoMaxPrice){
						lg('new bidder is auto');

						// this means new and current bidders are auto bidders
						// need to compare two max prices
						if(pro.AutoMaxPrice >= enoughPrice 
							&& pro.AutoMaxPrice > bidder.AutoMaxPrice)
						{

							lg('new bidder is higher');

							enoughPrice = +bidder.AutoMaxPrice + 1;
							bidder = {
								BidderId: userId,
								ProId: pro.Id,
								Price: enoughPrice,
								AutoMaxPrice: pro.AutoMaxPrice
							};
						}
						else if(pro.AutoMaxPrice >= enoughPrice 
							&& pro.AutoMaxPrice < bidder.AutoMaxPrice)
						{
							lg('new bidder is less');
							enoughPrice = +pro.AutoMaxPrice + 1;
						}
						else if(pro.AutoMaxPrice >= enoughPrice 
							&& pro.AutoMaxPrice == bidder.AutoMaxPrice)
						{
							lg('new bidder is equal');
							enoughPrice = +bidder.AutoMaxPrice;
						}
					}

					let record = {
						BidderId: bidder.BidderId,
						ProId: bidder.ProId,
						Price: enoughPrice,
						AutoMaxPrice: bidder.AutoMaxPrice
					};
					await db.save('bidderproduct', record);
					lg('save new bid');

					// highest price event
					await highestPriceEvent(bidder.BidderId);
				}
				else{
					await highestPriceEvent(userId);
				}


			}
			else{
				if(isBidAdvance === true && pro.AutoMaxPrice >= +price + +pro.PriceStep){
					// this means the new bidder is also auto and max price is higher
					let record = {
						BidderId: userId,
						ProId: pro.Id,
						Price: +price + +pro.PriceStep,
						AutoMaxPrice: pro.AutoMaxPrice
					};
					await db.save('bidderproduct', record);
					await highestPriceEvent(userId);
				}
				else if(isBidAdvance === true && pro.AutoMaxPrice < +price + +pro.PriceStep){
					await highestPriceEvent(bidder);
				}
				else if(isBidAdvance === false){
					await highestPriceEvent(userId);
				}

				
			}



			// return when done
			sql = `
			select a.*
			from product as p, account as a
			where p.Id = ${pro.Id} and p.OwnerId = a.Id
			`;
			let ownerx = await db.query(sql);

			sql = `
			select a.*
			from account as a
			where a.Id = ${userId}
			`;
			let userx = await db.query(sql);



			sendEmail(
				ownerx[0].Email,
				`[Auction web - product #${pro.Id}] Bidder bids`,
				`Recently a bidder has bidded successfully.`);

			sendEmail(
				userx[0].Email,
				`[Auction web - product #${pro.Id}] Congratulations`,
				`You has bidded successfully. The current price of product is updated.`);

			if(bidderx){
				sql = `
				select a.*
				from account as a
				where a.Id = ${bidderx.BidderId}
				`;
				let preBidder = await db.query(sql);

				sendEmail(
					preBidder[0].Email,
					`[Auction web - product #${pro.Id}] Another bidder has bidded`,
					`One bidder has recently bidded on the product you are highest bidder. Let's check it out.`);
			}

			//##################

			// if product can be bought instantly
			if(+pro.IsInstantBought === 1){

				let highest = await self.getHighestBidder(null, pro.Id);

				if(highest && +highest.Price >= +pro.EndPrice){
					// this bidder win this product
					// product ends
					lg('product ended by instant price');

					// update product table: winner id, current price
					let recordx = {
						WinnerId: highest.BidderId,
						CurrentPrice: highest.Price
					};
					await db.update('product', {Id: pro.Id}, recordx);

					// send email
					// send email owner
					let owner = await db.query(`
						select a.*
						from product as p, account as a
						where p.Id = ${pro.Id} and p.OwnerId = a.Id
						`);
					sendEmail(
						owner[0].Email,
						`[Auction web - product #${pro.Id}] Product finished.`,
						`Your product #${pro.Id} has just been finished. Let's check it out.`);

					// send email win bidder
					let bidder = await db.query(`
						select a.*
						from account as a
						where a.Id = ${highest.BidderId}
						`);
					sendEmail(
						bidder[0].Email,
						`[Auction web - product #${pro.Id}] Congratulations. Buy instantly.`,
						`Your product #${pro.Id} has just been finished and you bought instantly. Let's check it out.`
						);




				}
			}


			//##################

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

		return {isOk: false, history: []};
	},

	add: async (product)=>{
		// check instantBuy price >= startPrice
		if(product.EndPrice === null || product.EndPrice.match(/^ *$/) !== null){
			// if not define end price, just ignore it
			delete product.EndPrice;
		}
		else{
			// if defined, end price must valid (end price >= start + step price)
			let p1 = +product.EndPrice;
			let p2 = +product.StartPrice + +product.PriceStep;
			if(p1 < p2){
				return {isOk: false, msg: "The win price mustn't be less than total of start price and step price."};
			}
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

	},

	updateDescription: (id, description)=>{

		return db.update(table, {Id: id}, {Description: description});
	},

	bidders: async (proId)=>{
		lg(proId);
		let sql = 
		`
		select DISTINCT(b.BidderId), b.IsBanned, acc.Name
		from bidderproduct b, account acc
		where b.ProId = ${proId} and b.BidderId = acc.Id
		`;

		const results = await db.query(sql);

		return results;
	},

	updateBidders: async (proId, bidders)=>{

		if(!bidders){
			return {isOk: false};
		}

		// get highest bidder
		let bidder1 = await self.getHighestBidder(null, proId);


		for(let i = 0; i < bidders.length; i++){

			let idx = {
				BidderId: bidders[i].BidderId,
				ProId: proId
			};
			let setx ={
				IsBanned: (bidders[i].isBanned==='true')?1:0
			};
			let sql = `
			update bidderproduct 
			set IsBanned=${setx.IsBanned}
			where BidderId=${idx.BidderId} and ProId=${idx.ProId}
			`;
			let result = await db.query(sql);

			// send email
			let target = await db.query(`
				select a.*
				from account as a
				where a.Id = ${bidders[i].BidderId}
				`);
			let status = (bidders[i].isBanned==='true')?'banned':'un-banned';
			sendEmail(
				target[0].Email,
				`[Auction web - product #${proId}] You are ${status}`,
				`Owner has recently ${status} you from product #${proId}. Let's check it out.`);

		}

		// get highest bidder
		let bidder2 = await self.getHighestBidder(null, proId);
		lg(bidder1.BidderId);
		lg(bidder2.BidderId);
		if(bidder1.BidderId != bidder2.BidderId){
			highestPriceEvent(bidder2.BidderId);
		}

		return {isOk: true};
	},

	getHighestBidder: async(userId, proId)=>{

		let sql = `
		select * 
		from bidderproduct
		where ProId=${proId} 
		and Price >= all(select Price from bidderproduct where ProId = ${proId} and IsBanned = 0)
		and IsBanned = 0
		group by BidderId
		order by DateCreate asc
		`;
		let bidders = await db.query(sql);
		let bidder=null;
		if(bidders.length > 0 && bidders[0].BidderId !== +userId){
			bidder = bidders[0];
			lg('have current highest bidder: ' + bidder.BidderId);
		}
		else{
			bidder = null;
		}

		return bidder;
	}

}


