
const db = require('../utils/db');
const table = 'Catagory';

module.exports = {


	all: ()=>{
		return db.load(table);
	},

	single: async (id)=>{
		const results = await db.some(table, {Id: id});

		if(results != null && results.length > 0){
			return results[0];

		}
		return null;
	}

}