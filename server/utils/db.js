
const mysql = require('mysql');
const util = require('util');

const poolInfo = {
	connectionLimit: 10,
	host: 'localhost',
	port: 3306,
	user: 'irous12345678',
	password: 'irous12345678',
	database: 'auctionweb_1753102'
};


const pool = mysql.createPool(poolInfo);
const poolQuery = util.promisify(pool.query).bind(pool);

module.exports = {

	query: (sql)=>{
		return poolQuery(sql);
	},
	
	load: (table)=>{
		return poolQuery(`select * from ${table}`);
	},

	single: (table, condition)=>{
		let condition_sql = '';
		let count = 0;
		let prefix = '';
		if(Object.keys(condition).length > 1){
			Object.keys(condition).forEach(function(key) {
				prefix = ' and ';
				if(count === 0){
					prefix = '';
					count++;
				}

				condition_sql += prefix + key + "='" + condition[key] +"'";
			});
			log.log(condition_sql);
			return poolQuery(`select * from ${table} where ${condition_sql}`);
		}
		else{
			return poolQuery(`select * from ${table} where ?`, condition);
		}
	},
	
};


