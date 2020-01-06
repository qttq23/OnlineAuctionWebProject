const express = require('express');
const config = require('../config.json');
const restrict = require('../middlewares/authenMw');
const proModel = require('../models/proModel');
const cataModel = require('../models/cataModel');
const Jimp = require('jimp');
const router = express.Router();
module.exports = router;


router.get('/upload', restrict.authenSeller, function(req, res){
	lg('get product/upload');

	res.render('product/upload.html', {
		isLayoutSimple: true
	});

})

router.post('/upload', restrict.authenSeller, async function(req, res){
	lg('POST product/upload');

	// lg(req.body);
	// lg(req.files);

	let productRecord = {
		Name: req.body.nameInput,
		CatId: req.body.cataInput,
		StartPrice: req.body.startPriceInput,
		EndTime: req.body.endTimeInput,
		EndPrice: req.body.instantPriceInput,
		OwnerId: req.session.account.Id,
		IsAutoExtend: (req.body.autoExtendTimeInput === 'on')?1:0,
		ImageFolder: '/images/products',
		PriceStep: req.body.stepPriceInput,
		Description: req.body.descriptionInput,
	};
	lg(productRecord);
	const result = await proModel.add(productRecord);

	if(result.isOk === true){

		// save images
		if (!req.files || Object.keys(req.files).length === 0) {
			return res.json({isOk: false, msg: "Please provide 4 images to complete upload product."});
		}

		// The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
		let sampleFile = req.files.fileInput;
		// log.log(sampleFile);

		if(sampleFile.length >= 4){

			// create neccessary folders

			// save
			let count = 1;
			sampleFile.forEach(item=>{

				lg(item.name);

				// save with orignal format
				let dir = projectPath + `/static/images/products/${result.insertId}`;
				item.mv(dir + `/${count}.jpg`, function(err) {
					if (err)
						return res.json({isOk: false, msg: "Upload product images failed."});
				});



				count++;
			});

			return res.json({
				isOk: true, 
				msg: "Upload product info and images successfully.",
				redirect: `/product/uploadSuccess?proId=${result.insertId}`
			});
		}
		else{
			return res.json({isOk: false, msg: "Please provide 4 images to complete upload product."});
		}
	}

	res.json(result);
})

router.get('/uploadSuccess', restrict.authenSeller, function(req, res){
	lg('get product/uploadSuccess');

	res.render('product/uploadSuccess.html', {
		isLayoutSimple: true,

		proIdView: req.query.proId

	});

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



