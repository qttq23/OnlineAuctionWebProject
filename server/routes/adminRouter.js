
const express = require('express');

const config = require('../config.json');
const restrict = require('../middlewares/authenMw');

const proModel = require('../models/proModel');
const cataModel = require('../models/cataModel');
const accModel = require('../models/accModel');
const adminModel = require('../models/adminModel');

const router = express.Router();
module.exports = router;



router.get('/catagories', restrict.authenAdmin, async function(req, res){
	lg('GET all catgories');

	res.render('admin/catagories.html');
})


router.get('/catagories/details', restrict.authenAdmin, async function(req, res){
	lg('GET details catagory');
	lg(req.query);

	const result = await adminModel.cata(req.query.catId);
	lg(result);

	res.render('admin/catdetails.html', {
		cata: result
	});
})


router.post('/catagories/update', restrict.authenAdmin, async function(req, res){
	lg('POST cata update');
	lg(req.body);

	let catId = req.body.catId;
	let name = req.body.name;
	const result = await adminModel.cataUpdate(catId, name);
	lg(result);
	return res.json(result);

})


router.post('/catagories/delete', restrict.authenAdmin, async function(req, res){
	lg('POST cata delete');
	lg(req.body);

	let catId = req.body.catId;
	let countPro = req.body.countPro;
	const result = await adminModel.cataDelete(catId, countPro);
	lg(result);
	return res.json(result);

	// return res.json({isOk: false, msg: "failed to delete."});
})


router.post('/catagories/add', restrict.authenAdmin, async function(req, res){
	lg('POST cata add');
	lg(req.body);


	const result = await adminModel.cataAdd(req.body.name);
	lg(result);
	return res.json(result);

	// return res.json({isOk: false, msg: "failed to delete."});
})



router.get('/users', restrict.authenAdmin, async function(req, res){
	lg('GET all users');

	const users = await adminModel.users();
	const requests = await adminModel.requests();
	lg(users);
	lg(requests);

	res.render('admin/users.html', {
		users: users,
		isUserEmp: users.length === 0,
		requests: requests,
		isReqEmp: requests.length === 0 
	});
})


router.get('/users/details', restrict.authenAdmin, async function(req, res){
	lg('GET details user');
	lg(req.query);

	const result = await adminModel.user(req.query.userId);
	lg(result);

	res.render('admin/userdetails.html', {
		user: result
	});
})

router.post('/users/update', restrict.authenAdmin, async function(req, res){
	lg('POST users update');
	lg(req.body);

	let userId = req.body.userId;
	let type = req.body.type;
	const result = await adminModel.userUpdate(userId, type);
	lg(result);
	return res.json(result);

})


router.post('/users/clearRequests', restrict.authenAdmin, async function(req, res){
	lg('POST users clearRequests');
	lg(req.body);


	const result = await adminModel.clearRequests();
	lg(result);
	return res.json(result);

})




router.post('/users/delete', restrict.authenAdmin, async function(req, res){
	lg('POST users delete');
	lg(req.body);

	let userId = req.body.userId;
	const result = await adminModel.userDelete(userId);
	lg(result);
	return res.json(result);

	// return res.json({isOk: false, msg: "failed to delete."});
})



router.get('/posts', restrict.authenAdmin, async function(req, res){
	lg('GET posts');
	lg(req.query);

	const result = await adminModel.posts();
	lg(result);

	res.render('admin/posts.html', {
		posts: result
	});
})



router.post('/posts/delete', restrict.authenAdmin, async function(req, res){
	lg('POST posts delete');
	lg(req.body);

	let proId = req.body.proId;
	const result = await adminModel.postDelete(proId);
	lg(result);
	return res.json(result);

	// return res.json({isOk: false, msg: "failed to delete."});
})




