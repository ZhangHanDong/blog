function copyToClipboard(url) {
	var swf_copier = 'swf_copier';
	if(!document.getElementById(swf_copier)) {
		var divholder = document.createElement('div');
	  divholder.id = swf_copier;
	  document.body.appendChild(divholder);
	}
	document.getElementById(swf_copier).innerHTML = '';
	var embed_html = '<embed src="/_clipboard.swf" FlashVars="clipboard='+encodeURIComponent(url)+'" width="0" height="0" type="application/x-shockwave-flash"></embed>';
	document.getElementById(swf_copier).innerHTML = embed_html;
	$('copied_message').appear();
	new Effect.Highlight($('copied_message'));
}
