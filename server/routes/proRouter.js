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
	lg('get product, cata id = ' + req.query.catId + ', page = ' + req.query.page);

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


})