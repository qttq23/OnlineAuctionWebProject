

module.exports = {
	authen: (req, res, next)=> {
		if(!req.session.isAuthen){
			lg('redirect to login');
			lg('return to: ' + req.originalUrl);
			
			req.session.returnTo = req.originalUrl;
			return res.redirect(`../authen/login`);
		}

		next();
	}
}


