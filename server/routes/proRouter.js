const express = require('express');
const config = require('../config.json');
const restrict = require('../middlewares/authenMw');
const proModel = require('../models/proModel');
const cataModel = require('../models/cataModel');
const router = express.Router();
module.exports = router;


router.get('/add', restrict.authen, function(req, res){
	lg('get product/add');

	res.render('product/add.html');

})

router.get('/', async function(req, res){
	lg(req.query);

	if(!req.query.search){
		// get products
		const numPro = config.NumProOnPage;
		const offset = (req.query.page - 1)*numPro;
		const catId = req.query.catId;
		const results = await proModel.some(catId, numPro, offset);
		lg(results);
		const cata = await cataModel.single(catId);

		// show
		res.render('product/list.html', {

			cata: cata,

			total: cata.NumPro,
			onPage: config.NumProOnPage,
			isEmpty: cata.NumPro === 0,

			proList: results,
			page: req.query.page,
		});

	}
	else{
		// search
		const type = req.query.search;
		const keyword = req.query.key;
		const page = req.query.page;
		const numPro = config.NumProOnPage;
		const offset = (req.query.page - 1)*numPro;
		const results = await proModel.search(type, keyword, numPro, offset);

		lg(results);

		// show
		res.render('product/list.html', {

			isSearch: true,
			keySearch: keyword,
			searchType: type,

			total: results.total,
			onPage: numPro,
			isEmpty: results.total === 0,

			proList: results.list,
			page: page,
		});
	}

	


})