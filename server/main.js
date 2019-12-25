// global
global.log = require('./utils/myLog.js');
global.lg = ((object)=>{
	log.log(object);
})

global.projectPath = __dirname;

// require
const express = require('express');
const expHbs = require('express-handlebars');
const expHbsSec = require('express-handlebars-sections');
const expSession = require('express-session');
const numeral = require('numeral');
const moment = require('moment');

// load a locale
numeral.register('locale', 'vi', {
    delimiters: {
        thousands: ',',
        decimal: '.'
    },
    currency: {
        symbol: 'VNĐ'
    }
});
numeral.locale('vi');
moment.locale('vi');


// app
const app = express();

app.use(express.static('static'));

app.use(express.urlencoded({
	extended: true
})
);

app.use(expSession(
{
	secret: 'keyboard cat', 
	cookie: { maxAge: 60000*60 },
	resave: false,
	saveUninitialized: true,
})
);

app.engine('html', expHbs({
	defaultLayout: 'main.html',
	helpers: {

		section: expHbsSec(),

		cashConvert: function (number){
			// return numeral(number).format('0,0 $');
			return numeral(number).format('0,0 $');
		},
		dmyConvert: function(datetime){
			return moment(datetime).format('D/M/Y');
		},

		relativeDateTimeConvert: function(datetime){
			let a = moment();
			let b = moment(datetime);
			let diff = b.diff(a, 'seconds');
			console.log(diff);

			if(diff > 0 && diff > 86400){
				// more than 1 day
				console.log('case 1');
				return moment(datetime).format('D/M/Y, HH:mm');
			}
			else if(diff < 0 || (diff > 0 && diff <= 86400 && diff > 180)){
				// less than 1 day
				return b.from(a);
			}

		},


	}
})
);
app.set('view engine', 'html');



// client get, post
app.get('/', function(req, res){
	res.end('hello');
})


// app middleware
app.use(function(req, res, next){
	if(req.session.isAuthen === true){
		res.locals.userName = req.session.account.Name,
		res.locals.userType = req.session.account.AccType,
		res.locals.isAuthen = true;
	}

	next();
})

// home
const homeRouter = require('./routes/homeRouter');
app.use('/home', homeRouter);

// authentication
const authenRouter = require('./routes/authenRouter');
app.use('/authen', authenRouter);

// product
const proRouter = require('./routes/proRouter');
app.use('/product', proRouter);


// listen
const port = 3000;
app.listen(port, function(){
	log.log(`Server is running on: localhost:${port}`);
})



