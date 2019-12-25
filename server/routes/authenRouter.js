

const express = require('express');
const accModel = require('../models/accModel');
const config = require('../config.json');

const router = express.Router();
module.exports = router;

router.get('/login', function(req, res){
	log.log('Get login');

	if(!req.session.isAuthen){
		// render login page
		res.render('authen/login.html', {
			layout: false,
			isLoginRequired: true,
		});
	}
	else{
		// already login
		let url = req.headers.referer || '../home/';
		res.redirect(url);

	}
})

router.post('/login', async function(req, res){
	log.log('Post login');

	if(req.session.isAuthen === true){
		res.json({
			msg: 'You already logged in. please refresh your page.',
			isErr: true,
			isAlreadyLogin: true,
		});
	}
	else{
		let result = await accModel.single({
			Username: req.body.username,
			Password: req.body.password
		});

		log.log(result);

		let msg, isErr, userName, userType, returnTo;
		if(result != null){
			// success

			// session
			req.session.isAuthen = true;
			req.session.account = result;

			// client
			msg = 'success';
			isErr = false;
			userName = result.Name;
			userType = result.AccType;
			returnTo = req.session.returnTo || '/home/';
		}
		else{
			// fail

			// session
			req.session.isAuthen = false;
			req.session.account = null;

			// client
			msg = 'Please check your username and password';
			isErr = true;
		}



		let obj = { 
			msg: await (()=>msg)(),
			isErr: await (()=>isErr)(),
			userName: await(()=>userName)(),
			userType: await(()=>userType)(),
			returnTo: await(()=>returnTo)(),
		};
		res.json(obj);
	}
	
	
})

router.post('/logout', function(req, res){
	log.log('post logout');
	log.log('referrer: ' + req.headers.referer);

	// session
	req.session.isAuthen = false;
	req.session.account = null;

	// client
	res.redirect(req.headers.referer);
})



