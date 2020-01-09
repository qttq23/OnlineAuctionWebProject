

const express = require('express');

const config = require('../config.json');
const restrict = require('../middlewares/authenMw');

const proModel = require('../models/proModel');
const cataModel = require('../models/cataModel');
const accModel = require('../models/accModel');

const router = express.Router();
module.exports = router;










router.post('/watchlist/add', restrict.authen, async function(req, res){
	lg('POST watchlist add');
	lg(req.body);

	let proId = req.body.proId;
	let user = req.session.account;
	const result = await accModel.addWatchList(user, proId);
	lg(result);

	res.json(result);

})


router.post('/watchlist/remove', restrict.authen, async function(req, res){
	lg('POST watchlist remove');
	lg(req.body);

	let proId = req.body.proId;
	let user = req.session.account;
	const result = await accModel.removeWatchList(user, proId);
	lg(result);

	res.json(result);

})

router.get('/watchlist', restrict.authen, async function(req, res){
	lg('GET watchlist');
	lg(req.query);

	// get products
	const numPro = config.NumProOnPage;
	const offset = (req.query.page - 1)*numPro;
	const userId = req.session.account.Id;
	const results = await accModel.watchList(userId, numPro, offset);
	lg(results);

	// show
	res.render('acc/watchlist.html', {

		total: results.total,
		onPage: config.NumProOnPage,
		isEmpty: results.list.length === 0,

		proList: results.list,
		page: req.query.page,
		isInWatchList: true,
	});
})


router.get('/biddinglist', restrict.authen, async function(req, res){
	lg('GET biddinglist');
	lg(req.query);

	// get products
	const numPro = config.NumProOnPage;
	const offset = (req.query.page - 1)*numPro;
	const userId = req.session.account.Id;
	const results = await accModel.biddingList(userId, numPro, offset);
	lg(results);

	// show
	res.render('acc/biddinglist.html', {

		total: results.total,
		onPage: config.NumProOnPage,
		isEmpty: results.list.length === 0,

		proList: results.list,
		page: req.query.page
	});
})


router.get('/wonlist', restrict.authen, async function(req, res){
	lg('GET wonlist');
	lg(req.query);

	// get products
	const numPro = config.NumProOnPage;
	const offset = (req.query.page - 1)*numPro;
	const userId = req.session.account.Id;
	const results = await accModel.wonList(userId, numPro, offset);
	lg(results);

	// show
	res.render('acc/wonlist.html', {

		total: results.total,
		onPage: config.NumProOnPage,
		isEmpty: results.list.length === 0,

		proList: results.list,
		page: req.query.page
	});
})




router.get('/profile', restrict.authen, async function(req, res){
	lg('GET profile');
	lg(req.session.account);

	let acc = req.session.account;
	// const results = accModel.profile(acc);

	res.render('acc/profile.html', {
		// layout: 'simple.html',
		isLayoutSimple: true,

		account:{
			name: acc.Name,
			address: acc.Address,
			birthday: acc.Birthday,
			email: acc.Email,
			accType: acc.AccType,
			point: acc.Point
		}
	});
})

router.post('/profile/update', restrict.authen, async function(req, res){
	lg('POST profile');
	lg(req.session.account);
	lg(req.body);

	let acc = req.session.account;
	let info = req.body.updateInfo;
	const results = await accModel.updateProfile(acc, info);

	lg(results);
	if(results.isOk === true){
		// re-set info for user
		const newAccInfo = await accModel.single({Id:acc.Id});
		lg(newAccInfo);
		req.session.account = newAccInfo;

		// redirect
		results.redirect = req.headers.referer || '../home';
	}

	res.json(results);
})


router.get('/password/change', restrict.authen, async function(req, res){
	lg('GET /password/change');
	lg(req.session.account);
	

	res.render('acc/changePassword.html',{
		// layout: 'simple.html',
		isLayoutSimple: true,
	});

})


router.post('/password/change', restrict.authen, async function(req, res){
	lg('POST /password/change');
	lg(req.session.account);
	lg(req.body);

	let acc = req.session.account;
	let info = req.body.password;
	const results = await accModel.changePassword(acc, info);

	lg(results);
	if(results.isOk === true){
		// re-set info for user
		const newAccInfo = await accModel.single({Id:acc.Id});
		lg(newAccInfo);
		req.session.account = newAccInfo;

		// redirect
		results.redirect = '/acc/password/success';
	}

	res.json(results);
})


router.get('/password/success', restrict.authen, async function(req, res){
	lg('GET /password/success');
	lg(req.session.account);
	

	res.render('acc/changePasswordSuccess.html',{
		// layout: 'simple.html',
		isLayoutSimple: true,
	});

})


router.post('/upgrade/request', restrict.authen, async function(req, res){
	lg('POST /upgrade/request');
	lg(req.session.account);
	lg(req.body);

	let acc = req.session.account;
	const results = await accModel.requestUpgrade(acc);

	lg(results);
	res.json(results);
})



router.get('/commentrate', restrict.authen, async function(req, res){
	lg('GET /commentrate');
	lg(req.query);
	
	// let acc = req.session.account;
	// const results = await accModel.listRate(acc);
	// lg(results);

	let accId = req.query.userId;
	const results = await accModel.listRate(accId);
	lg(results);

	let target = null;
	if(req.session.account.Id != +accId){
		target = await accModel.single({Id:accId});
	}
	lg(target);

	res.render('acc/commentrate.html',{
		total: results.list.length,
		numLike: results.numLike,
		list: results.list,

		target: target
	});

})


// not test
router.post('/commentrate/add', restrict.authen, async function(req, res){
	lg('POST /commentrate/add');
	lg(req.body);

	// get products
	const fromId = req.session.account.Id;
	const toId = req.body.toId;
	const point = req.body.point;
	const comment = req.body.comment;
	const proId = req.body.proId;
	const result = await accModel.addRate(fromId, toId, point, comment, proId);
	lg(result);

	// show
	res.json(result);
})


router.get('/postlist', restrict.authenSeller, async function(req, res){
	

	lg('GET postlist');
	lg(req.query);

	// get products
	const numPro = config.NumProOnPage;
	const offset = (req.query.page - 1)*numPro;
	const userId = req.session.account.Id;
	const results = await accModel.postList(userId, numPro, offset);
	lg(results);

	// show
	res.render('acc/postlist.html', {

		total: results.total,
		onPage: config.NumProOnPage,
		isEmpty: results.list.length === 0,

		proList: results.list,
		page: req.query.page,
		isInWatchList: false,
	});
})

router.get('/finishlist', restrict.authenSeller, async function(req, res){
	

	lg('GET postlist');
	lg(req.query);

	// get products
	const numPro = config.NumProOnPage;
	const offset = (req.query.page - 1)*numPro;
	const userId = req.session.account.Id;
	const results = await accModel.finishList(userId, numPro, offset);
	lg(results);

	// show
	res.render('acc/finishlist.html', {

		total: results.total,
		onPage: config.NumProOnPage,
		isEmpty: results.list.length === 0,

		proList: results.list,
		page: req.query.page,
		isInWatchList: false,
	});
})

router.post('/finishlist/remove', restrict.authenSeller, async function(req, res){
	lg('POST /finishlist/remove');
	lg(req.body);
	lg(req.session.account);

	// get products
	const acc = req.session.account;
	const proId = req.body.proId;
	const result = await accModel.removeFinish(acc, proId);
	lg(result);

	// show
	res.json(result);
})