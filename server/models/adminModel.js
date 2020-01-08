


const db = require('../utils/db');
const bcrypt = require('bcryptjs');





module.exports = {

	cata: async (catId)=>{

		let result = null;

		const list = await db.some('catagory', {Id: catId});
		if(list != null && list.length >= 1){
			result = list[0];
		}
		
		return result;
	},

	cataUpdate: async(catId, name)=>{

		const result = await db.update('catagory', {Id: catId}, {Name: name});
		if(result.affectedRows > 0){
			return {isOk: true, msg: "Edit name successfully."};
		}
		return {isOk: false, msg: "Edit name failed."};
	},

	cataDelete: async(catId, countPro)=>{

		if(countPro != 0){
			return {isOk: false, msg: "Catagory still has products."};
		}

		// table catagory
		const result = await db.delete('catagory', {Id: catId});
		if(result.affectedRows > 0){
			return {isOk: true, msg: "Delete catagory successfully."};
		}
		return {isOk: false, msg: "Delete catagory failed."};
	},

	cataAdd: async(name)=>{

		// table catagory
		let result = await db.save('catagory', {Name: name});
		lg(result);
		if(result.affectedRows > 0){

			// get cata
			result = await db.some('catagory', {Id: result.insertId});
			lg(result);
			return {
				isOk: true, 
				msg: "Add catagory successfully.",
				cata: result[0]
			};
		}
		return {
			isOk: false, 
			msg: "Add catagory failed."
		};
	},

	users: async ()=>{
		let sql = 
		`	
		select *
		from account
		where AccType != 3
		`;
		const results = await db.query(sql);
		return results;
	},

	requests: async()=>{
		let sql = 
		`
		select u.*, a.Name, a.AccType
		from upgraderequest u, account a
		where u.FromId = a.Id
		`;
		const results = await db.query(sql);
		return results;
	},

	clearRequests: async()=>{
		let sql = 
		`
		DELETE FROM upgraderequest
		WHERE 1 = 1
		`;
		const results = await db.query(sql);
		if(results.affectedRows > 0)
		{
			return {isOk: true, msg: 'clear all requests successfully.'};
		}
		return {isOk: false, msg: 'clear all requests failed.'};
	},

	user: async (userId)=>{

		let result = null;

		const list = await db.some('account', {Id: userId});
		if(list != null && list.length >= 1){
			result = list[0];
		}
		
		return result;
	},


	userUpdate: async(userId, type)=>{

		const result = await db.update('account', {Id: userId}, {AccType: type});
		if(result.affectedRows > 0){
			return {isOk: true, msg: "Edit user successfully."};
		}
		return {isOk: false, msg: "Edit usre failed."};
	},

	userDelete: async(userId)=>{


		// table catagory
		const result = await db.delete('account', {Id: userId});
		if(result.affectedRows > 0){
			return {isOk: true, msg: "Delete user successfully."};
		}
		return {isOk: false, msg: "Delete user failed."};
	},

	posts: async()=>{
		let sql = 
		`
		select p.*, c.Name as CatName
		from product p, catagory c
		where p.CatId = c.Id
		`;
		const results = await db.query(sql);
		return results;
	},

	postDelete: async(proId)=>{


		// table product
		const result = await db.delete('product', {Id: proId});
		if(result.affectedRows > 0){
			return {isOk: true, msg: "Delete post successfully."};
		}
		return {isOk: false, msg: "Delete post failed."};
	},


}