
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

	some: (table, condition)=>{
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

	save: (table, record)=>{
		return poolQuery(`insert into ${table} set ?`, [record]);
	},

	update: (table, id, record) => poolQuery(`update ${table} set ? where ?`, [record, id]),

	fullTextSearch: (table, columns, keyword)=>{
		
		let columns_sql = '(';
		let count = 0;
		columns.forEach(item=>{
			if(count === 0){
				count++;
				columns_sql += item;
			}
			else{
				columns_sql += ',' + item;
			}
		});
		columns_sql += ')';
		log.log(columns_sql);

		return poolQuery(`select ${table}.*, match ${columns_sql} against ('$${keyword}*' in boolean mode) as score` +
			` from ${table}`+
			` where match ${columns_sql} against ('$${keyword}*' in boolean mode) > 0 ` +
			`order by score `);


		// reference:https://stackoverflow.com/questions/9121778/fulltext-mysql-search-not-working
	},

	delete: (table, condition)=>{

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
			return poolQuery(`delete from ${table} where ${condition_sql}`);
		}
		else{
			return poolQuery(`delete from ${table} where ?`, condition);
		}

	}
	
};


