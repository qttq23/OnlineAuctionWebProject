

const express = require('express');
const accModel = require('../models/accModel');
const config = require('../config.json');
const bcrypt = require('bcryptjs');
var nodemailer = require('nodemailer');
var request = require('request');
const util = require('util');
const requestPromise = util.promisify(request);


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

		// check username
		let result = await accModel.single({
			Username: req.body.username,
			// Password: req.body.password
		});

		log.log(result);

		let msg, isErr, userName, userType, returnTo;
		// check password
		if(result != null
			&& result.AccType > 0 	// account is active
			&& bcrypt.compareSync(req.body.password, result.Password)
			)
		{

			// success

			// session
			req.session.isAuthen = true;
			req.session.account = result;

			// client
			msg = 'success';
			isErr = false;
			userName = result.Name;
			userType = result.AccType;
			returnTo = req.session.returnTo || '/home';

			lg(returnTo);
			
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



		// let obj = { 
		// 	msg: await (()=>msg)(),
		// 	isErr: await (()=>isErr)(),
		// 	userName: await(()=>userName)(),
		// 	userType: await(()=>userType)(),
		// 	returnTo: await(()=>returnTo)(),
		// };
		let obj = { 
			msg: msg,
			isErr: isErr,
			userName: userName,
			userType: userType,
			returnTo: returnTo,
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


router.get('/signup', function(req, res){
	log.log('GET sign up');

	res.render(
		'authen/signup.html',
		{
			layout: 'simple.html',
		});
})

router.post('/signup', async function(req, res){
	lg('POST sign up');
	lg(req.body);

	// check recaptcha
	if(req.body['g-recaptcha-response'] === undefined || req.body['g-recaptcha-response'] === '' || req.body['g-recaptcha-response'] === null) {
		return res.json({
			isError: true,
			msg: 'Please select captcha',
			"responseCode" : 1,
			"responseDesc" : "Please select captcha"
		});
	}

	// Hitting GET request to the URL, Google will respond with success or error scenario.
	var secretKey = "6LernMoUAAAAALGsNfGg0ZvKfYUy2_vibI1HINaK";
	var verificationUrl = "https://www.google.com/recaptcha/api/siteverify?secret=" + secretKey + "&response=" + req.body['g-recaptcha-response'] + "&remoteip=" + req.connection.remoteAddress;
	
	const response = await requestPromise(verificationUrl);
	// console.log('response', response.body);
	lg('google request done');
	lg(response.body);
	let body = JSON.parse(response.body);

	// Success will be true or false depending upon captcha validation.
	if(body.success !== undefined && !body.success) {
		return res.json({
			isError: true,
			msg: 'Captcha validation failed. Please reload this page and try again.',
			"responseCode" : 1,
			"responseDesc" : "Failed captcha verification"
		});
	}

	lg('checkCaptcha done');

	// check account
	const account = {
		// Id: String(-1),
		Username: req.body.inUsername,
		Password: req.body.inPassword,
		// AccType: 0,
		// Point: 0,
		Name: req.body.inFullName,
		Address: req.body.inAddress,
		Birthday: req.body.inBirthday,
		Email: req.body.inEmail,

	};
	const result = await accModel.validate(account);

	// show
	if(result.res == true){

		// generate unique OTP
		const max = 1000000;
		let randomInt = (low, high) => {
			return Math.floor(Math.random() * (high - low) + low);
		}
		let otp = randomInt(100000, 1000000);
		lg(otp);

		// ssign to session
		req.session.otp = otp;
		req.session.accIdNotActive = result.accId;
		lg("active code: " + req.session.otp);


		// send to email
		var transporter = nodemailer.createTransport({
			service: 'gmail',
			auth: {
				user: 'buithang1999a@gmail.com',
				pass: 'buithang1999'
			}
		});

		var mailOptions = {
			from: 'buithang1999a@gmail.com',
			to: account.Email,
			subject: 'verification number',
			// text: String(otp)
			html: `<h4>This is your active code: ${otp}</h4>`,
		};

		transporter.sendMail(mailOptions, function(error, info){
			if (error) {
				console.log(error);
			} else {
				console.log('Email sent: ' + info.response);
			}
		});

		// show user
		res.json({
			isError: false,
			msg: 'redirect',
			url: '/authen/signupActive'
		});


	}
	else{
		// res.send(result.msg);
		res.json({
			isError: true,
			msg: result.msg
		});
	}

	

})


router.get('/signupActive', function(req, res){
	lg('GET active');

	res.render('authen/signupActive.html',{layout: 'simple.html'});
})

router.post('/signupActive', async function(req, res){
	lg('POST active');

	lg(req.body.otp);
	lg(req.session.otp);

	// check
	if(req.session.otp == req.body.otp){
		// active account
		const result = await accModel.active(req.session.accIdNotActive);
		if(result){

			// success 
			res.json({
				isError: false
			});
		}
		else{
			// send err
			res.json({
				isError: true,
				msg: "Fail to active your account. Please create another account."
			});
		}
	}	
	else{
		// send err
		res.json({
			isError: true,
			msg: "Wrong verification number. Please check your email and try again."
		});
	}
	
})


router.get('/signupSuccess')

