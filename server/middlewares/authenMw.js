

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
	},

	authenSeller: (req, res, next)=>{

		// authen
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

		// must be seller
		if(req.session.account.AccType !== 2){
			// not a seller
			return res.render('error/error.html',{
				isLayoutSimple: true,
				title: 'Account level error',
				description: 'You must be a seller to use this feature.'
			});

		}

		next();
	},

	authenAdmin: (req, res, next)=>{

		// authen
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

		// must be admin
		if(req.session.account.AccType !== 3){
			// not a seller
			return res.render('error/error.html',{
				isLayoutSimple: true,
				title: 'Account level error',
				description: 'You must be an admin to use this feature.'
			});

		}

		next();
	}
}


