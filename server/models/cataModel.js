
const db = require('../utils/db');
const table = 'Catagory';

module.exports = {


	all: ()=>{
		// return db.load(table);

		let sql =
		`
		select c.*, count(p.Id) as CountPro
		from catagory as c
		left join product as p 
		
		on c.Id = p.CatId
		group by c.Id
		`;
		return db.query(sql);
		;
	},

	single: async (id)=>{
		let sql =
		`
		select c.*, count(p.Id) as CountPro
		from catagory as c left join product as p 
		on c.Id = p.CatId
		where c.Id = ${id}
		
		group by c.Id
		`;


		const results = await db.query(sql);

		if(results != null && results.length > 0){
			return results[0];

		}
		return null;
	}

}