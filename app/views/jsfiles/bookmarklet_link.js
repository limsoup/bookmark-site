	javascript:(function(){
		jq=document.createElement('SCRIPT');
		jq.type='text/javascript';
		jq.src='//localhost:3000/assets/jquery_bookmarklet.min.js';
		document.getElementsByTagName('head')[0].appendChild(jq);
		bmk=document.createElement('SCRIPT');
		bmk.type='text/javascript';
		bmk.src='//localhost:3000/jsfiles/bookmarklet.js';
		document.getElementsByTagName('head')[0].appendChild(bmk);
	})();

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

/*
	ujs=document.createElement('SCRIPT');
	ujs.type='text/javascript';
	ujs.src='//localhost:3000/assets/jquery_ujs_bookmarklet.js';
	document.getElementsByTagName('head')[0].appendChild(ujs);
*/