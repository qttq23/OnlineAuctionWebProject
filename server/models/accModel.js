
const db = require('../utils/db');
const table = 'account';

module.exports = {
	single: async (userpass)=>{

		let result = null;

		const list = await db.single(table, userpass);
		if(list != null){
			result = list[0];
		}
		
		return result;
	},


}