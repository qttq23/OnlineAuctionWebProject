

function checkPassword(input){
	if(input.length < 8){
		return false;
	}
	else{
		return true;
	}
}

function checkSamePassword(input1, input2){


	if(input1 == input2){
		// alert('equal');
		return true;
	}
	else{
		return false;
	}
}

function checkEmail(input){
	var patt = /^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$/i;
	var result = input.match(patt);
	return result;
}

function checkName(input){
	var patt = /[A-Z][a-zA-Z][^#&<>\"~;$^%{}?]{1,20}$/g;
	var result = input.match(patt);
	return result;
}

function checkBirthday(input){
	var patt = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/;
	var result = input.match(patt);
	if(!result){
		$('.birthdayDiv .errorPrompt').html('Birthday is not valid.');
	}
	else{
		$('.birthdayDiv .errorPrompt').html('');
	}
	return result;
}