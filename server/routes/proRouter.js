const express = require('express');
const config = require('../config.json');
const restrict = require('../middlewares/authenMw');
const router = express.Router();
module.exports = router;


router.get('/add', restrict.authen, function(req, res){
	lg('get product/add');

	res.render('product/add.html');

})