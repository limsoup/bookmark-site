javascript:(function(){
/*
	if(typeof jQuery != "function") {
		jq=document.createElement('SCRIPT');
		jq.type='text/javascript';
		jq.src='//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js';
		document.getElementsByTagName('head')[0].appendChild(jq);
	}
	if (parseFloat($().jquery.toString().slice(0,3)) != 1.9.1 ){
		jq=document.createElement('SCRIPT');
		jq.type='text/javascript';
		jq.src='//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js';
		document.getElementsByTagName('head')[0].appendChild(jq);
	}
*/
// we serve:jq.min.js and it'll have the noconflict call tagged on the end to give it a different namespace
// we serve:jq_ujs.min.js is served by us, we use the namespace given above
	jq=document.createElement('SCRIPT');
	jq.type='text/javascript';
	jq.src='http://localhost:3000/jsfiles/jquery.min.js';
	document.getElementsByTagName('head')[0].appendChild(jq);
	bmk=document.createElement('SCRIPT');
	bmk.type='text/javascript';
	bmk.src='http://localhost:3000/jsfiles/bookmarklet.js';
	document.getElementsByTagName('head')[0].appendChild(bmk);
	ujs=document.createElement('SCRIPT');
	ujs.type='text/javascript';
	ujs.src='http://localhost:3000/assets/jquery_ujs.js';
	document.getElementsByTagName('head')[0].appendChild(ujs);
})();