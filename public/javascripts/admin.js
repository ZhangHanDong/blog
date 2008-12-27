/* from http://www.tek-tips.com/viewthread.cfm?qid=1465395&page=5 */

function copyToClipboard(url) {
	var flashcopier = 'flashcopier';
	if(!document.getElementById(flashcopier)) {
	  var divholder = document.createElement('div');
	  divholder.id = flashcopier;
	  document.body.appendChild(divholder);
	}
	document.getElementById(flashcopier).innerHTML = '';
	var divinfo = '<embed src="/_clipboard.swf" FlashVars="clipboard='+encodeURIComponent(url)+'" width="0" height="0" type="application/x-shockwave-flash"></embed>';
	document.getElementById(flashcopier).innerHTML = divinfo;
	$('copied_message').appear();
	new Effect.Highlight($('copied_message'));
	return url;
}