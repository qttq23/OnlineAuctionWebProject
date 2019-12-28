
const db = require('../utils/db');
const bcrypt = require('bcryptjs');
const table = 'account';

module.exports = {
	single: async (userpass)=>{

		let result = null;

		const list = await db.single(table, userpass);
		if(list != null && list.length >= 1){
			result = list[0];
		}
		
		return result;
	},

	validate: async (account)=>{

		let result = null;
		let space = ' ';

		if(!account.Username.includes(space)){

			// check unique username
			const instance = await db.single(table, {Username: account.Username});

			if(instance != null && instance.length >= 1){
				lg(instance[0]);

				result = {
					res: false,
					msg: "Username already exists. Please choose another username."
				};

			}
			else{

				if(account.Password.length >= 8){

					// hash password
					let salt = bcrypt.genSaltSync(10);
					account.Password = bcrypt.hashSync(account.Password, salt);


					if(account.Email.match(/^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$/i)
						!= null)
					{
						// check unique email
						const instanceEmail = await db.single(table, {Email: account.Email});

						if(instanceEmail != null && instanceEmail.length >= 1){
							result = {
								res: false,
								msg: "Email must be unique. Please provide different email."
							};

						}
						else{

							if(account.Name.match(/[A-Z][a-zA-Z][^#&<>\"~;$^%{}?]{1,20}$/g)
								!= null
								)
							{
								if(account.Birthday.match(/([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/)
									!= null)
								{
									// save to database
									lg('saving to database...')
									const res = await db.save(table, account);
									lg(res);
									if(res.insertId){
										result = {
											res: true,
											msg: "New account has been added to database.",
											accId: res.insertId
										};
									}
									else{
										result = {
											res: false,
											msg: "Fail to insert new account to database."
										};
									}
								}
								else{
									result = {
										res: false,
										msg: "Birthday not valid. right format: YYYY-MM-DD"
									};

								}
							}
							else{
								result = {
									res: false,
									msg: "Full name must start with capital characters."
								};
							}
						}	
						

						
					}
					else{
						result = {
							res: false,
							msg: "Email not valid. Please check your Email and enter again."
						};
					}
				}
				else{
					result = {
						res: false,
						msg: "Password have to be more than 8 characters to make it more security."
					};
				}
			}


			
		}
		else{
			result = {
				res: false,
				msg: "Username can't include space. Please remove any spaces in your username."
			};
		}

		return result;
	},

	active: async (id)=>{

		const accountId = {Id: id};
		const active = {AccType: 1};
		const result = await db.update(table, accountId, active);

		lg(result);
		return result;
	},



}