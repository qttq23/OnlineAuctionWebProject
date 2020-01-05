

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


router.post('/commentrate', restrict.authen, async function(req, res){
	lg('POST commentrate');
	lg(req.body);

	// get products
	const fromId = req.session.account.Id;
	const toId = req.body.toId;
	const point = req.body.point;
	const comment = req.body.comment;
	const result = await accModel.commentRate(fromId, toId, point, comment);
	lg(result);

	// show
	res.json(result);
})




