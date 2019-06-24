
var bets = {
	cover: null,
	
	init: function()
	{
		bets.current = document.getElementsByClassName('btsCurrentBets')[0];
		bets.recent = document.getElementsByClassName('btsRecentBets')[0];
		bets.xats = document.getElementsByClassName('btsXats')[0];
		bets.cover = document.getElementsByClassName('btsCover')[0];
		bets.make = document.getElementsByClassName('btsMakeBet')[0];
		bets.makeinfo = document.getElementsByClassName('btsMakeBetInfo')[0];
		bets.loadBets();
		bets.makeHTML();
		setInterval(function() {if (bets.current.style.display == "block") bets.loadBets(); else bets.loadRecentBets();}, 30 * 1000);
	},
	
	makeHTML: function() {
		if (bets.current.style.display == 'block') {//loadbets
			var form = document.createElement('form');
			form.onsubmit = 'return false;';
			form.innerHTML += '<input type="text" id="btsBetAmount" name="amount" size="15" maxlength="20" onkeyup="this.value = numFormat(this.value)"><br><br>';
			form.innerHTML += '<button onclick="bets.makeBet(); return false;" class="btn btn-xs btn-danger" type="button" title="Bets 100k or higher will get posted to chat">Make Bet</button>';
					
			bets.make.innerHTML = '';
			bets.make.appendChild(form);
			
			var div = document.createElement('div');
			div.className = 'row gap-y';
			div.innerHTML = '<div class="col-2"><button onclick="bets.loadBets(); bets.makeHTML(); return false;" class="btn btn-xs btn-info" type="button">Refresh</button></div>';
			div.innerHTML += '<div class="col-7">Amount of xats to bid. (minimum of 1,000 xats bet)</div>';
			div.innerHTML += '<div class="col-3"><button onclick="bets.loadRecentBets(); bets.makeHTML(); return false;"class="btn btn-xs btn-info" type="button">Recent Bets</button></div>';
			
			bets.makeinfo.innerHTML = '';
			bets.makeinfo.appendChild(div);
		} else {//loadrecentbets
			bets.make.innerHTML = '';
			
			var div = document.createElement('div');
			div.className = 'row gap-y';
			div.innerHTML = '<div class="col-2"><button onclick="bets.loadRecentBets(); bets.makeHTML(); return false;" class="btn btn-xs btn-info" type="button">Refresh</button></div>';
			div.innerHTML += '<div class="col-7">Xat bets taken or placed recently</div>';
			div.innerHTML += '<div class="col-3"><button onclick="bets.loadBets(); bets.makeHTML(); return false;"class="btn btn-xs btn-info" type="button">Current Bets</button></div>';
			
			bets.makeinfo.innerHTML = '';
			bets.makeinfo.appendChild(div);
		}
	},
	
	loadBets: function(page)
	{
		bets.current.style.display = 'block';
		bets.recent.style.display = 'none';
		bets.coverShow();
		bets.GET("/5050?ajax=currentBets", bets.writeBets);
	},
	
	
	loadRecentBets: function(page)
	{
		bets.current.style.display = 'none';
		bets.recent.style.display = 'block';
		bets.coverShow();
		bets.GET("/5050?ajax=recentBets", bets.writeRecentBets);
	},
	
	coverHide: function()
	{
		if(bets.cover.style.opacity != 0)
		{
			bets.cover.style.opacity = 0;
			setTimeout(function() { bets.cover.style.display = 'none'; }, 260);
		}
	},
	
	coverShow: function()
	{
		if(bets.cover.style.opacity != 1)
		{
			bets.cover.style.display = 'block';
			bets.cover.style.opacity = 1;
		}
	},
	
	makeBet: function()
	{
		var betAmount = document.getElementById('btsBetAmount');
		bets.coverShow();
		bets.POST(
			'/5050?ajax=makeBet',
			'amount=' + encodeURIComponent(betAmount.value),
			function(aJson)
			{
				var result = JSON.parse(aJson);
				
				if(result.success)
				{
					$.notify('Bet made successfully. I hope you win!', 'info');
					bets.loadBets();
					bets.xats.innerHTML = numFormat(result.xats);
				}
				else
				{
					$.notify('An error occured, please review.\n' + result.reason, 'error');
					bets.coverHide();
				}
			}
		);
		
		return false;
	},
	
	writeBets: function(aJson)
	{
		var r = JSON.parse(aJson);
		bets.alerts = r.bets;
		
		if(bets.alerts.length == 0)
		{
			bets.current.innerHTML = "<center>Looks like you don't have any bets!</center>";
		}
		else
		{
			bets.current.innerHTML = '';
			
			for(var i = 0; i < bets.alerts.length; i++)
			{
				var div = document.createElement('div');
				div.className = 'row gap-y';
				div.innerHTML = '<div class="col-2"></div><div class="col-2"><a target="_blank" href="https://xat.im/' + bets.alerts[i].user + '">' + bets.alerts[i].user + '</a></div>';
				div.innerHTML += '<div class="col-3">' + numFormat(bets.alerts[i].amount) + ' xats</div>';
				if (bets.alerts[i].self) {
					div.innerHTML += '<div class="col-2"><button class="btn btn-info btn-xs" onclick="bets.removeBet(' + bets.alerts[i].id + ')">Remove Bet</button></div>';
				} else {
					div.innerHTML += '<div class="col-2"><button class="btn btn-danger btn-xs" onclick="bets.takeBet(' + bets.alerts[i].id + ')">Take Bet</button></div>';
				}
				
				bets.current.appendChild(div);
			}
			
		}
		bets.xats.innerHTML = numFormat(r.xats);
		bets.coverHide();
	},	
	
	writeRecentBets: function(aJson)
	{
		var r = JSON.parse(aJson);
		bets.alerts = r.bets;
		
		if(bets.alerts.length == 0)
		{
			bets.recent.innerHTML = "<center>Looks like you don't have any recent bets!</center>";
		}
		else
		{
			bets.recent.innerHTML = '';
			
			var div = document.createElement('div');
			div.className = 'row gap-y';
			div.innerHTML = '<div class="col-2"></div><div class="col-2">Amount</div>';
			div.innerHTML += '<div class="col-2">Status</div>';
			div.innerHTML += '<div class="col-4">Time</div>';
			
			bets.recent.appendChild(div);
			
			for(var i = 0; i < bets.alerts.length; i++)
			{
				var status = bets.alerts[i].status == 0 ? 'Removed' : bets.alerts[i].winner == r.id ? 'Win' : 'Loss';
				var color = bets.alerts[i].status == 0 ? 'yellow' : bets.alerts[i].winner == r.id ? 'green' : 'red';
				var title = bets.alerts[i].status == 0 ? '' : bets.alerts[i].user + ' ' + (r.id == bets.alerts[i].winner ? 'Lost' : 'Won');
				var div = document.createElement('div');
				div.className = 'row gap-y';
				div.innerHTML = '<div class="col-2"></div><div class="col-2">' + numFormat(bets.alerts[i].amount) + ' xats</div>';
				div.innerHTML += '<div class="col-2" title="' + title + '"><font color="' + color + '">' + status + '</font></div>';
				div.innerHTML += '<div class="col-4">' + bets.tsToDate(bets.alerts[i].time) + '</div>';
				
				bets.recent.appendChild(div);
			}
			
		}
		bets.xats.innerHTML = numFormat(r.xats);
		bets.coverHide();
	},
	
	takeBet: function(e)
	{
		bets.coverShow();
		bets.POST(
			'/5050?ajax=takeBet',
			'id=' + e,
			function(aJson)
			{
				var result = JSON.parse(aJson);
				
				if(result.success)
				{
					$.notify(result.outcome, 'info');
					bets.loadBets();
					bets.xats.innerHTML = numFormat(result.xats);
				}
				else
				{
					$.notify('An error occured, please review.\n' + result.reason, 'error');
					bets.coverHide();
				}
			}
		);
	},
	
	removeBet: function(e)
	{
		bets.coverShow();
		bets.POST(
			'/5050?ajax=removeBet',
			'id=' + e,
			function(aJson)
			{
				var result = JSON.parse(aJson);
				
				if(result.success)
				{
					$.notify(result.outcome, 'info');
					bets.loadBets();
					bets.xats.innerHTML = numFormat(result.xats);
				}
				else
				{
					$.notify('An error occured, please review.\n' + result.reason, 'error');
					bets.coverHide();
				}
			}
		);
	},
	
	GET: function(url, callback)
	{
		bets.xmlCall = callback;
		bets.xmlHttp = new XMLHttpRequest();
		bets.xmlHttp.onreadystatechange = bets.XHChange;
		bets.xmlHttp.open('GET', url, true);
		bets.xmlHttp.send(null);
	},
	
	POST: function(url, params, callback)
	{
		bets.xmlCall = callback;
		bets.xmlHttp = new XMLHttpRequest();
		bets.xmlHttp.onreadystatechange = bets.XHChange;
		bets.xmlHttp.open('POST', url, true);
		bets.xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		bets.xmlHttp.send(params);
	},
	
	XHChange: function()
	{
		if(bets.xmlHttp.readyState == 4 && bets.xmlHttp.status == 200)
		{
			bets.xmlCall(bets.xmlHttp.responseText);
		}
	},
	
	tsToDate: function(ts)
	{
		var a = new Date(ts * 1000);
		var month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][a.getMonth()];
		var year = a.getFullYear();
		var date = a.getDate();
		var hour = Math.abs(a.getHours() - (a.getHours() == 12 ? 11:12));
		var min = a.getMinutes() < 10 ? "0" + a.getMinutes() : a.getMinutes();
		var sec = a.getSeconds() < 10 ? "0" + a.getSeconds() : a.getSeconds();
		var meridiem = a.getHours() > 12 ? 'pm' : 'am';
		var time = month + ' ' + date + ', ' + year + ' ' + hour + ':' + min + ':' + sec + meridiem;
		return time;
	}
}

function intFormat(n) {
    var a = /(\d)((\d{3},?)+)$/;
    n = n.split(',').join('');
    while (a.test(n)) {
        n = n.replace(a, '$1,$2')
    }
    return n
}

function numFormat(n) {
    var a = /([\d,\.]*)\.(\d*)$/,
        f;
	n = n.toString();
    if (a.test(n)) {
        f = RegExp.$2;
        return intFormat(RegExp.$1) + '.' + f
    }
    return intFormat(n)
}

if(document.readyState == "complete" || document.readyState == "loaded")
{ // Initiate if already loaded
	bets.init();
}
else
{
	window.addEventListener(
		'DOMContentLoaded',
		function()
		{ // in case bets.init isn't defined
			bets.init();
		}
	);
}