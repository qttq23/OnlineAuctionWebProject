

const express = require('express');
const cataModel = require('../models/cataModel');
const proModel = require('../models/proModel');
const config = require('../config.json');

const router = express.Router();
module.exports = router;


router.get('/', async function(req, res){
	console.log("Get homepage");

	const cataList = await cataModel.all();
	const nearEndProList = await proModel.nearEnd(config.NumProInListHomePage);
	const mostTurnProList = await proModel.mostTurn(config.NumProInListHomePage);
	const highestPriceProList = await proModel.highestPrice(config.NumProInListHomePage);


	res.render('home/home.html', {
		cataList: cataList,
		nearEndPro: nearEndProList,
		mostTurnPro: mostTurnProList,
		highestPricePro: highestPriceProList,
		
	});
})



