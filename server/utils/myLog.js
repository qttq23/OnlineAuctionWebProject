
var nodemailer = require('nodemailer');

var isLog = true;


module.exports = {
	getIsLog: ()=> {return isLog;},

	setIsLog: value =>{
		isLog = value;
	},

	log: object => {
		
		if(isLog){
			console.log(object);
		}
	},
	error: object =>{
		if(isLog){
			console.error(object);
		}
	},
	sendEmail: (toEmail, subject, content)=>{

		console.log(toEmail);
		console.log(subject);
		console.log(content);
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
			to: toEmail,
			subject: subject,
			html: content,
		};

		transporter.sendMail(mailOptions, function(error, info){
			if (error) {
				console.log(error);
			} else {
				console.log('Email sent: ' + info.response);
			}
		});
	},
}