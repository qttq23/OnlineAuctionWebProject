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
	}
}