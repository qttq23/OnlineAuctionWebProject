

module.exports = {
	authen: (req, res, next)=> {
		if(!req.session.isAuthen){
			lg('redirect to login');
			lg('return to: ' + req.originalUrl);
			
			req.session.returnTo = req.originalUrl;

			// form prefix
			let prefix = '';
			let tokens = req.originalUrl.split('/');	// ex: /acc/password/change -> acc,password,change
			for(let i = 0; i < tokens.length - 1; i++){
				prefix += '/..';						// -> /../..
			}
			return res.redirect(`${prefix}/authen/login`);
		}

		next();
	}
}


