const express = require('express');
const config = require('../config.json');
// const restrict = require('../middlewares/authenMw');
const proModel = require('../models/proModel.js');

const router = express.Router();
module.exports = router;


router.get('/', async function(req, res){
	lg('get cata id = ' + req.query.id);

	// get products
	const results = await proModel.some(req.query.id, config.numProOnPage, 0);

	// show
	res.render('product/list.html', {
		cataId: ,
		proList: ,
	});


})