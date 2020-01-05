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

router.get('/details', async function(req, res){
	lg('GET details');
	lg(req.query);

	// get product details
	const result = await proModel.single(req.query.id);
	lg(result);

	if(result != null){
		
		// get 6 products with same catagory
		const relatedList = await proModel.some(result.CatId, 6, 0);
		lg(relatedList);

		// check if any products same as current detailed product
		for(let i = 0; i < relatedList.length; i++){

			if(relatedList[i].Id === result.Id){
				relatedList.splice( i, 1);
				break;
			}

			if(i === 5){
				relatedList.splice( i, 1);
				break;
			}
		}



		res.render('product/details.html', {
			product: result,
			relatedList: relatedList,
		});
	}
	else{
		// show error page
	}

})

router.post('/price', async function(req, res){

	lg('query price:');
	lg(req.body);

	const userId = req.body.userId;
	const pro = req.body.pro;

	// get price according to user
	const result = await proModel.getPrice(userId, pro);

	lg(result);
	res.json(result);
})

router.post('/bid', async function(req, res){
	lg('bid price');
	lg(req.body);

	const userId = req.body.userId;
	const pro = req.body.pro;
	const price = req.body.price;

	// check and update user bid product table
	const result = await proModel.setBid(userId, pro, price);

	lg(result);
	if(result.isOk){
		result.redirect = req.headers.referer || '../home';
	}
	res.json(result);
})


router.get('/history', async function(req, res){
	lg('GET bid history');
	lg(req.query);

	let proId = req.query.id;
	const results = await proModel.getHistory(proId);
	lg(results);

	res.json(results);

})