/* from http://blog.peelmeagrape.net/2008/8/30/time-ago-in-words-javascript-part-2 */
/* amended prefix to work with future differences - matthewhutchinson.net */

TimeInWordsHelper = {
  distanceInWords: function(fromTime, toTime, includeSeconds) {
    var fromSeconds = fromTime.getTime();
    var toSeconds = toTime.getTime();
    var distanceInSeconds = Math.round(Math.abs(fromSeconds - toSeconds) / 1000)    
    var distanceInMinutes = Math.round(distanceInSeconds / 60)
    var prefix = ' ago';
    if((fromSeconds - toSeconds) < 0)
      var prefix = ' from now';
    
    if (distanceInMinutes <= 1) {
      if (!includeSeconds)
        return (distanceInMinutes == 0) ? 'less than a minute' + prefix : '1 minute' + prefix
      if (distanceInSeconds < 5)
        return 'less than 5 seconds' + prefix
      if (distanceInSeconds < 10)
        return 'less than 10 seconds' + prefix
      if (distanceInSeconds < 20)
        return 'less than 20 seconds' + prefix
      if (distanceInSeconds < 40)
        return 'half a minute' + prefix
      if (distanceInSeconds < 60)
        return 'less than a minute' + prefix
      return '1 minute' + prefix
    }
    if (distanceInMinutes < 45)
      return distanceInMinutes + ' minutes' + prefix
    if (distanceInMinutes < 90)
      return "about 1 hour" + prefix
    if (distanceInMinutes < 1440)
      return "about " + (Math.round(distanceInMinutes / 60)) + ' hours' + prefix
    if (distanceInMinutes < 2880)
      return "1 day" + prefix
    if (distanceInMinutes < 43200)
      return (Math.round(distanceInMinutes / 1440)) + ' days' + prefix
    if (distanceInMinutes < 86400)
      return "about 1 month" + prefix
    if (distanceInMinutes < 525600)
      return (Math.round(distanceInMinutes / 43200)) + ' months' + prefix
    if (distanceInMinutes < 1051200)
      return "about 1 year" + prefix
    return "over " + (Math.round(distanceInMinutes / 525600)) + ' years' + prefix
  },
  convertBySelector: function(selector) {
    var now = new Date()
    $$(selector).each(function(e) {
      var oldInner = e.innerHTML
      var date = new Date();
      date.setISO8601(e.title);
      e.innerHTML = TimeInWordsHelper.distanceInWords(now, date, false)
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