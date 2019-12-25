
const db = require('../utils/db');
const table = 'Catagory';

module.exports = {


	all: ()=>{
		return db.load(table);
	},
}