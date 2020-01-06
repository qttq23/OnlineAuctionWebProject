


$(()=>{

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

})



function remainSeconds(datetime){
	let a = moment();
	let b = moment(datetime);
	let diff = b.diff(a, 'seconds');
	console.log(diff);

	return diff;
}

function relativeDateTimeConvert(datetime){

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

}

function dmyhmsConvert(datetime){

	return moment(datetime).format('D/M/Y, HH:mm:ss');
}

function datetimeConvert(datetime, format){
	console.log(moment(datetime).format(format));
	return moment(datetime).format(format);
}

function cashConvert (number){
	// return numeral(number).format('0,0 $');
	return numeral(number).format('0,0 $');
}

function shortenName(longName){
	if(!longName){
		return '';
	}

	if(longName.length >= 40){
		longName = longName.substring(0, 35).concat('...');
	}

	return longName;
}

function maskenName(longName){
	if(!longName){
		return '';
	}

	let tokens = longName.split(' ');
	if(tokens != null && tokens.length > 1){
		longName = tokens[tokens.length - 1];
	}
	if(longName.length > 7){
		longName = longName.substring(0, 7);
	}

	longName = '***' + longName;
	return longName;
}
