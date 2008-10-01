/* from http://blog.peelmeagrape.net/2008/8/30/time-ago-in-words-javascript-part-2 */
/* amended prefix to work with future differences - matthewhutchinson.net */

TimeInWordsHelper = {
  distanceInWords: function(fromTime, toTime, includeSeconds, includePostfix) {
    var fromSeconds = fromTime.getTime();
    var toSeconds = toTime.getTime();
    var distanceInSeconds = Math.round(Math.abs(fromSeconds - toSeconds) / 1000)    
    var distanceInMinutes = Math.round(distanceInSeconds / 60)
		var distanceInWords   = '';
		
    var postfix = ' ago';
    if((fromSeconds - toSeconds) < 0)
      var postfix = ' from now';

    if (distanceInMinutes <= 1)
		{
      if (!includeSeconds)
        (distanceInMinutes == 0) ? distanceInWords = 'less than a minute' : distanceInWords = '1 minute'
      else if (distanceInSeconds < 5)
        distanceInWords = 'less than 5 seconds'
      else if (distanceInSeconds < 10)
        distanceInWords = 'less than 10 seconds'
      else if (distanceInSeconds < 20)
        distanceInWords = 'less than 20 seconds'
      else if (distanceInSeconds < 40)
        distanceInWords = 'half a minute'
      else if (distanceInSeconds < 60)
        distanceInWords = 'less than a minute'
      else 
	    distanceInWords = '1 minute'
    } 
	else
	{
    if (distanceInMinutes < 45)
      distanceInWords = distanceInMinutes + ' minutes'
    else if (distanceInMinutes < 90)
      distanceInWords = "about 1 hour"
    else if (distanceInMinutes < 1440)
      distanceInWords = "about " + (Math.round(distanceInMinutes / 60)) + ' hours'
    else if (distanceInMinutes < 2880)
      distanceInWords = "1 day"
    else if (distanceInMinutes < 43200)
      distanceInWords = (Math.round(distanceInMinutes / 1440)) + ' days'
    else if (distanceInMinutes < 86400)
      distanceInWords = "about 1 month"
    else if (distanceInMinutes < 525600)
      distanceInWords = (Math.round(distanceInMinutes / 43200)) + ' months'
    else if (distanceInMinutes < 1051200)
      distanceInWords = "about 1 year"
    else
    	distanceInWords = "over " + (Math.round(distanceInMinutes / 525600)) + ' years'
	}

	if(includePostfix)
		return distanceInWords + postfix;
	else
		return distanceInWords;
		
  },
  convertBySelector: function(selector) {
    var now = new Date()
    $$(selector).each(function(e) {
      var oldInner = e.innerHTML
      var toDate = new Date();
      toDate.setISO8601(e.title);
      e.innerHTML = TimeInWordsHelper.distanceInWords(now, toDate, true, true)
      e.title = oldInner
    });
  }
};


/* parsing of Date from IS08601 format to Date object - matthewhutchinson.net */
Date.prototype.setISO8601 = function (string) {
    var regexp = "([0-9]{4})(-([0-9]{2})(-([0-9]{2})" +
        "(T([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?" +
        "(Z|(([-+])([0-9]{2}):([0-9]{2})))?)?)?)?";

    var d = string.match(new RegExp(regexp));
    var offset = 0;
    var date = new Date(d[1], 0, 1);

    if (d[3]) { date.setMonth(d[3] - 1); }
    if (d[5]) { date.setDate(d[5]); }
    if (d[7]) { date.setHours(d[7]); }
    if (d[8]) { date.setMinutes(d[8]); }
    if (d[10]) { date.setSeconds(d[10]); }
    if (d[12]) { date.setMilliseconds(Number("0." + d[12]) * 1000); }
    if (d[14]) {
        offset = (Number(d[16]) * 60) + Number(d[17]);
        offset *= ((d[15] == '-') ? 1 : -1);
    }

    offset -= date.getTimezoneOffset();
    time = (Number(date) + (offset * 60 * 1000));
    this.setTime(Number(time));
}