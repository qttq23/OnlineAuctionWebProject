
const db = require('../utils/db');
const bcrypt = require('bcryptjs');
const table = 'account';



module.exports = {

	single: async (userpass)=>{

		let result = null;

		const list = await db.some(table, userpass);
		if(list != null && list.length >= 1){
			result = list[0];
		}
		
		return result;
	},

	validate: async (account)=>{

		let result = null;
		let space = ' ';

		if(!account.Username.includes(space)){

			// check unique username
			const instance = await db.single(table, {Username: account.Username});

			if(instance != null && instance.length >= 1){
				lg(instance[0]);

				result = {
					res: false,
					msg: "Username already exists. Please choose another username."
				};

			}
			else{

				if(account.Password.length >= 8){

					// hash password
					let salt = bcrypt.genSaltSync(10);
					account.Password = bcrypt.hashSync(account.Password, salt);


					if(account.Email.match(/^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$/i)
						!= null)
					{
						// check unique email
						const instanceEmail = await db.single(table, {Email: account.Email});

						if(instanceEmail != null && instanceEmail.length >= 1){
							result = {
								res: false,
								msg: "Email must be unique. Please provide different email."
							};

						}
						else{

							if(account.Name.match(/[A-Z][a-zA-Z][^#&<>\"~;$^%{}?]{1,20}$/g)
								!= null
								)
							{
								if(account.Birthday.match(/([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/)
									!= null)
								{
									// save to database
									lg('saving to database...')
									const res = await db.save(table, account);
									lg(res);
									if(res.insertId){
										result = {
											res: true,
											msg: "New account has been added to database.",
											accId: res.insertId
										};
									}
									else{
										result = {
											res: false,
											msg: "Fail to insert new account to database."
										};
									}
								}
								else{
									result = {
										res: false,
										msg: "Birthday not valid. right format: YYYY-MM-DD"
									};

								}
							}
							else{
								result = {
									res: false,
									msg: "Full name must start with capital characters."
								};
							}
						}	
						

						
					}
					else{
						result = {
							res: false,
							msg: "Email not valid. Please check your Email and enter again."
						};
					}
				}
				else{
					result = {
						res: false,
						msg: "Password have to be more than 8 characters to make it more security."
					};
				}
			}


			
		}
		else{
			result = {
				res: false,
				msg: "Username can't include space. Please remove any spaces in your username."
			};
		}

		return result;
	},

	active: async (id)=>{

		const accountId = {Id: id};
		const active = {AccType: 1};
		const result = await db.update(table, accountId, active);

		lg(result);
		return result;
	},

	addWatchList: async (acc, proId)=>{

		// check account
		if(!acc){
			return {isOk: false, msg: "Please login to use this feature."};
		}
		
		let record = {AccountId: acc.Id, ProId: proId};
		const result = await db.save('watchlist', record);
		if(result.affectedRows >= 1){
			return {isOk: true, msg: "Add product to watchlist successfully."};
		}

		return {isOk: false, msg: "Add product to watchlist failed."};
	},

	removeWatchList: async (acc, proId)=>{

		// check account
		if(!acc){
			return {isOk: false, msg: "Please login to use this feature."};
		}
		
		let record = {AccountId: acc.Id, ProId: proId};
		const result = await db.delete('watchlist', record);
		lg(result);

		if(result.affectedRows >= 1){
			return {isOk: true, msg: "Remove product from watchlist successfully."};
		}

		return {isOk: false, msg: "Remove product from watchlist failed."};
	},

	// nested query
	watchList: async (accId, numPro, offset)=>{
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, b.Turn, b.Price as Max_Price, b.BidderId
		from (select DISTINCT pro.*
		from product as pro, watchlist as wat
		where wat.AccountId = ${accId} and wat.ProId = pro.Id

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

		// ok
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
	},

	// nested query
	biddingList: async (accId, numPro, offset)=>{
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, b.Turn, b.Price as Max_Price, b.BidderId
		from (select DISTINCT pro.*
		from product as pro, bidderproduct as bid
		where bid.BidderId = ${accId} and bid.ProId = pro.Id and bid.isBanned = 0

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

		// ok
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
	},


	// nested query
	wonList: async (accId, numPro, offset)=>{
		let sql = `
		select t2.*, owner.Name as OwnerName, owner.Point as OwnerPoint, bidder.Name as BidderName, bidder.Point as BidderPoint
		from (select sortedPro.*, b.Turn, b.Price as Max_Price, b.BidderId
		from (select DISTINCT pro.*
		from product as pro, bidderproduct as bid
		where bid.BidderId = ${accId} and bid.ProId = pro.Id 
		and bid.isBanned = 0 and bid.isWin = 1

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

		// ok
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
	},


	addRate: async (fromId, toId, point, comment)=>{

		let record = {
			FromId: fromId,
			ToId: toId,
			Point: point,
			Message: comment
		};
		const result = await db.save('commentrate', record);

		if(result.affectedRows >= 1){
			return {isOk: true, msg: "Comment and rate successfully."};
		}

		return {isOk: false, msg: "Comment and rate failed."};

	},

	listRate: async (acc)=>{
		let sql =`
		select c.*, a1.Name as FromUserName
		from commentrate as c, account a1
		where c.ToId = ${acc.Id}
		and c.FromId = a1.Id
		order by c.DateCreate asc
		`;

		let sql2 =`
		select count(*) as numLike
		from commentrate as c, account a1
		where c.ToId = ${acc.Id}
		and c.FromId = a1.Id
		and c.Point = 1
		`;

		const res = await db.query(sql);
		const res2 = await db.query(sql2);
		return {list: res, numLike: res2[0].numLike};
	},


	updateProfile: async (acc, newInfo)=>{

		let record = newInfo;
		const result = await db.update(table, {Id: acc.Id}, record);
		if(result.affectedRows >= 1){
			return {isOk: true, msg: 'Update account information successfully.'};
		}

		return {isOk: false, msg: 'Update account information failed.'};

	},

	changePassword: async (acc, password)=>{

		// check if current pass = old pass
		if(bcrypt.compareSync(password.old, acc.Password) === false){
			return {isOk: false, msg: "You entered wrong old password"};
		}


		// if all ok
		// hash new password
		let salt = bcrypt.genSaltSync(10);
		let newPassword = bcrypt.hashSync(password.new, salt);


		const result = await db.update(table, {Id: acc.Id}, {Password: newPassword});
		if(result.affectedRows >= 1){
			return {isOk: true, msg: 'Change Password successfully.'};
		}

		return {isOk: false, msg: 'Change Password failed.'};

	},

	requestUpgrade: async (acc)=>{

		// check if account is a bidder
		if(acc.AccType !== 1){
			return {isOk: false, msg: 'You are not bidder to request upgrade.'};
		}

		// if all ok
		const result = await db.save('upgraderequest', {FromId: acc.Id});
		if(result.affectedRows >= 1){
			return {isOk: true, msg: 'Send upgrade request successfully. Admin will respond to you soon.'};
		}

		return {isOk: false, msg: 'Send upgrade request failed.'};

	}

}