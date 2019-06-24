/* * *
 *  @Author Skyflare [skype=fluffycoder]
 *   Personal Website: http://fluffycoder.net/
 *   Last Modified~ 10/12/15 ~Techy
 */

var support = {
	cover: null,
	
	init: function()
	{
		support.content = document.getElementsByClassName('sptContent')[0];
		support.cover = document.getElementsByClassName('sptCover')[0];
		support.loadTickets();
		
		document.getElementById('sptOpen').addEventListener('click', support.loadTickets);
		
		document.getElementById('sptArchived').addEventListener(
			'click', function()
			{
				support.coverShow();
				support.GET("/support?ajax=tickets&archived", support.archivedTickets);
			}
		);
		
		document.getElementById('sptNew').addEventListener(
			'click', function()
			{
				var form = document.createElement('form');
				form.onsubmit = 'return false;';
				form.innerHTML += '<label for="newTicketSubject">Subject</label><input maxlength="64" size="50" type="text" name="newTicketSubject" placeholder="..." />';
				form.innerHTML += '<button onclick="support.newTicketSubmit(); return false;">Submit</button><br />';
				form.innerHTML += '<textarea name="newTicketContent" placeholder="Describe your problem... (max 4096 characters)"></textarea>';
				
				support.content.innerHTML = '';
				support.content.appendChild(form);
			}
		);	
	},
	
	loadTickets: function(page)
	{
		support.coverShow();
		var staffPage = '.staff&pn=' + (typeof(page) == typeof(1) ? page : 1);
		support.GET("/support?ajax=tickets" + (supportAdmin || supportHelper ? staffPage : ''), support.writeTickets);
	},
	
	coverHide: function()
	{
		if(support.cover.style.opacity != 0)
		{
			support.cover.style.opacity = 0;
			setTimeout(function() { support.cover.style.display = 'none'; }, 260);
		}
	},
	
	coverShow: function()
	{
		if(support.cover.style.opacity != 1)
		{
			support.cover.style.display = 'block';
			support.cover.style.opacity = 1;
		}
	},
	
	newTicketSubmit: function()
	{
		var ticketSubject = document.getElementsByName('newTicketSubject')[0];
		var ticketContent = document.getElementsByName('newTicketContent')[0];
		var ticketContinue = true;
		
		if(ticketSubject.value.length < 8)
		{
			ticketContinue = false;
			ticketSubject.style.borderColor = '#ff0000';
			ticketSubject.title = 'Your subject is too small!';
		}
		else if(ticketSubject.value.length > 64)
		{
			ticketContinue = false;
			ticketSubject.style.borderColor = '#ff0000';
			ticketSubject.title = 'Your subject is too big!';
		}
		else
		{
			ticketSubject.title = '';
			ticketSubject.style.borderColor = '#00ff00';
		}
		
		if(ticketContent.value.length < 20)
		{
			ticketContinue = false;
			ticketContent.style.borderColor = '#ff0000';
			ticketContent.title = "Your description is too small, it must consist of at LEAST 20 letters.";
		}
		else if(ticketContent.value.length > 4096)
		{
			ticketContinue = false;
			ticketContent.style.borderColor = '#ff0000';
			ticketContent.title = 'Your description is too big, max 4096 letters.';
		}
		else
		{
			ticketContent.title = '';
			ticketContent.style.borderColor = '#00ff00';
		}
		
		if(ticketContinue)
		{
			support.coverShow();
			support.POST(
				'/support?ajax=newticket',
				'ticketSubject=' + encodeURIComponent(ticketSubject.value) + '&ticketContent=' + encodeURIComponent(ticketContent.value),
				function(aJson)
				{
					var result = JSON.parse(aJson);
					
					if(result.success)
					{
						support.loadTickets();
					}
					else
					{
						$.notify('An error occured, please review.\n' + result.reason, 'error');
						support.coverHide();
					}
				}
			);
		}
		else
		{
			$.notify('One or more errors occured while trying to create your ticket.\r\nHover over the field(s) with a red border to see what you did wrong.', 'error');
		}
		
		return false;
	},
	
	archivedTickets: function(aJson)
	{
		var r = JSON.parse(aJson);
		support.alerts = r.tickets;
		
		if(support.alerts.length == 0)
		{
			support.content.innerHTML = "<center>Looks like you don't have any tickets!</center>";
		}
		else
		{
			var div = document.createElement('div');
			div.className = 'table-responsive';
			var table = document.createElement('table');
			table.className = "table table-bordered table-hover table-striped";
			table.width = '100%';
			table.innerHTML += '<thead><tr> <th width="100px"> Ticket ID </th> <th width="200px"> Subject </th> <th width="250px"> Last Response </th> <th> Department </th> </tr></thead>';
			
			div.appendChild(table);
			support.content.innerHTML = '';
			support.content.appendChild(div);
			
			var tbody = document.createElement("tbody");
			
			for(var i = 0; i < support.alerts.length; i++)
			{
				var tr = document.createElement('tr');
				tr.id = "ticketNode" + support.alerts[i].tid;
				//tr.className  = ['d', 'l'][i % 2];
				tr.innerHTML  = '<th> ' + support.alerts[i].tid + ' </th>';
				tr.innerHTML += '<th> ' + support.alerts[i].subject + ' </th>';
				tr.innerHTML += '<th> ' + support.tsToDate(support.alerts[i].last_response_time) + ' </th>';
				tr.innerHTML += '<th> ' + support.alerts[i].dept + ' </th>';
				//tr.innerHTML += '<th> <button class="actView" onclick="support.actView(' + support.alerts[i].tid + ')" style="width:100%">View</button> </th>';
				//tr.innerHTML += '<th> <button onclick="support.actArchive(' + support.alerts[i].tid + ')" style="width:100%">Archive</button> </th>';
				
				tbody.appendChild(tr);
			}
			table.appendChild(tbody);
			
		}
		
		support.coverHide();
	},
	
	writeTickets: function(aJson)
	{
		var r = JSON.parse(aJson);
		support.alerts = r.tickets;
		
		if(support.alerts.length == 0)
		{
			support.content.innerHTML = "<center>Looks like you don't have any tickets!</center>";
		}
		else
		{
			var div = document.createElement('div');
			div.className = 'table-responsive';
			var table = document.createElement('table');
			table.className = "table table-bordered table-hover table-striped";
			table.width = '100%';
			//table.innerHTML += '<tr class="h"> <th width="100px"> Ticket Creator (UID) </th> <th width="200px"> Title </th> <th width="250px"> Last Response </th> <th> Department </th> <th width="75px"> View </th> <th width="75px"> Archive </th> </tr>';
			//table.innerHTML += '<thead> <tr> <th width="100px">User ID</th> <th width="200px">Title</th> <th width="250px">Last Response</th> <th>Department</th> <th width="75px">View</th> <th width="75px">Archive</th> </tr> </thead>';
			table.innerHTML += '<thead> <tr> <th width="75px">User ID</th> <th width="200px">Subject</th> <th width="250px">Last Response</th> <th>Department</th> <th width="200px">Actions</th> </tr> </thead>';
			
			
			div.appendChild(table);
			support.content.innerHTML = '';
			support.content.appendChild(div);
			
			var tbody = document.createElement("tbody");
			
			for(var i = 0; i < support.alerts.length; i++)
			{
				var tr = document.createElement('tr');
				tr.id = "ticketNode" + support.alerts[i].tid;
				//tr.className  = ['d', 'l'][i % 2];
				tr.innerHTML  = '<th> ' + support.alerts[i].ticketmaster + ' </th>';
				tr.innerHTML += '<th> ' + support.alerts[i].subject + ' </th>';
				tr.innerHTML += '<th> ' + support.tsToDate(support.alerts[i].last_response_time) + ' </th>';
				if(support.alerts[i].dept == "users") 
				{
					tr.innerHTML += '<th> <span class="label label-primary">' + support.alerts[i].dept + '</span> </th>';
				}
				else if(support.alerts[i].dept == "admin")
				{
					tr.innerHTML += '<th> <span class="label label-warning">' + support.alerts[i].dept + '</span> </th>';
				}
				//tr.innerHTML += '<th> <button class="btn btn-primary" onclick="support.actView(' + support.alerts[i].tid + ')" style="width:100%">View</button> </th>';
				//tr.innerHTML += '<th> <button class="btn btn-danger" onclick="support.actArchive(' + support.alerts[i].tid + ')" style="width:100%">Archive</button> </th>';
				tr.innerHTML += '<th><button class="btn btn-primary btn-xs" onclick="support.actView(' + support.alerts[i].tid + ')">View</button> ' +
				'<button class="btn btn-danger btn-xs" onclick="support.actArchive(' + support.alerts[i].tid + ')">Archive</button></th>';
				
				tbody.appendChild(tr);
			}
			
			table.appendChild(tbody);
		}
		
		if(supportAdmin || supportHelper)
		{
			var pages = Math.ceil(r.ticketCount / 15);
			var startingPage = parseInt(r.currentPage - 5 < 1 ? 1 : r.currentPage - 5);
			var lastPage = (startingPage + 9 > pages ? pages : startingPage + 9);
			
			var pn = document.createElement('div');
			pn.className = 'btn btn-group btn-small btn-daniel btn-flat disabled';
			pn.innerHTML = 'Pages';
			
			//var pn = document.createElement('div');
			//pn.className = 'pageNumber';
			//pn.innerHTML = '&lt;&lt;';
			//pn.addEventListener('click', support.loadTickets);
			support.content.appendChild(pn);
			
			for(var i = startingPage; i < lastPage; i++)
			{
				//var pn = document.createElement('div');
				//pn.className = 'pageNumber';
				//pn.innerHTML = i;
				var pn = document.createElement('div');
				pn.className = 'btn btn-group btn-small btn-daniel btn-flat';
				pn.innerHTML = i;
				pn.addEventListener('click', function() { support.loadTickets(parseInt(this.innerHTML)); } );
				support.content.appendChild(pn);
			}
			
			//var pn = document.createElement('div');
			//pn.className = 'pageNumber';
			//pn.innerHTML = '&gt;&gt;';
			//pn.addEventListener('click', function() { support.loadTickets(pages); } );
			//support.content.appendChild(pn);
		}
		
		support.coverHide();
	},
	
	actView: function(e)
	{
		support.coverShow();
		support.GET('/support?ajax=ticket&id=' + e, support.actViewTicket);
	},
	
	actViewTicket: function(e)
	{
		var t = JSON.parse(e);
		var ticket = t.ticket;
		support.currentTicket = t;
		
		if(t.status)
		{
			support.content.innerHTML = '<h1>' + ticket.subject + '</h1> <br /> <small> (Department: ' + ticket.dept + ') </small>';;
			
			support.sptActResponse = document.createElement('div');
			support.content.appendChild(support.sptActResponse);
			
			if(t.admin || t.helper)
			{
				var adActbox = document.createElement('div');
				adActbox.className = "actbox";
				support.content.appendChild(adActbox);
				
				var dynBlock = document.createElement('h2');
				var dynInput = document.createElement('input');
				
				dynBlock.title = "This is the ID to which the actions below will be applied";
				dynBlock.innerHTML = t.admin ? "Action User ID <small>(hover)</small>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" : "";
				dynInput.type = t.admin ? 'text' : "hidden";
				
				dynInput.id = 'supportActionId';
				dynInput.value = ticket.ticketmaster;
				dynBlock.appendChild(dynInput);
				adActbox.appendChild(dynBlock);
				
				var buttons = [
					'Torch/Untorch',
					'Transfer logs',
					/*'Trade logs',*/
					'IPBan'
				];
				
				if(ticket.dept == 'users')
					buttons.push("Elevate to admin dept");
				buttons.push('Close Ticket');
				
				for(var bi = buttons.length - 1; bi > -1; bi--)
				{
					var actBtn = document.createElement('div');
					actBtn.className = 'action';
					actBtn.innerHTML = buttons[bi];
					actBtn.style.float = 'right';
					actBtn.addEventListener('mousedown', support.actButtonClick);
					adActbox.appendChild(actBtn);
				}
			}
			
			/* Ticket Content & Comments */
			var ticketContentBox = document.createElement('div');
			ticketContentBox.className = "tcb";
			support.content.appendChild(ticketContentBox);
			ticketContentBox.innerHTML = '<h1>' + t.ticket.ticketmaster_un + '</h1>' + t.ticket.content;
			
			var ticketCommentBox = document.createElement('div');
			ticketCommentBox.className = 'tcb';
			
			t.comments.sort( function(a, b) { return b['cid'] - a['cid'] } );
			for(var i in t.comments)
			{ // tcb = ticketcontentbox / ticketcommentbox
				var tc = document.createElement('div');
				tc.className = 'tcb';
				tc.innerHTML = '<h1>' + t.comments[i].pun + '&nbsp;&nbsp;<small><i>(' + support.tsToDate(t.comments[i].timestamp) + ')</i></small></h1>' + t.comments[i].content;
				support.content.appendChild(tc);
			}
			
			var ticketTextArea = document.createElement('textarea');
			ticketTextArea.className = "ticketcommentbox";
			ticketTextArea.id = "ticketTextArea";
			ticketCommentBox.appendChild(ticketTextArea);
			
			support.content.appendChild(ticketCommentBox);
			
			var ticketHeading = document.createElement('h1');
			ticketHeading.innerHTML = 'Type your response above&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="support.ticketReplySubmit(); return false;">Submit</button>';
			ticketCommentBox.appendChild(ticketHeading);
		}
		else
		{
			$.notify('An error occured,\n' + e.reason, 'error');
		}
		
		support.coverHide();
	},
	
	ticketReplySubmit: function()
	{
		var comment = document.getElementById('ticketTextArea');
		if(comment.value.length == 0)
		{
			$.notify('Please post something to reply...', 'warning');
		}
		else if(comment.value.length > 4096)
		{
			$.notify('Not such a big reply please (4096 letters max)', 'warning');
		}
		else
		{
			support.coverShow();
			support.POST('/support?ajax=ticketreplysubmit', 'tid=' + support.currentTicket.ticket.tid + '&post=' + encodeURIComponent(comment.value), support.ticketReplyParse);
		}
	},
	
	ticketReplyParse: function(e)
	{
		support.coverHide();
		var r = JSON.parse(e);
		
		if(r.success)
		{
			support.actView(r.tid);
		}
		else
		{
			$.notify('Failed to post ticket, ' + r.reason, 'error');
		}
	},
	
	actButtonClickResponse: function(e)
	{
		support.sptActResponse.innerHTML = '';
		support.coverHide();
		var r = JSON.parse(e);
		
		if(r.showMessage)
		{
			var messageBox = document.createElement('div');
			messageBox.className = 'message';
			messageBox.innerHTML = r.showMessage;
			messageBox.addEventListener('click', function() { this.style.display = 'none'; });
			support.sptActResponse.appendChild(messageBox);
		}
		
		if(['Torch/Untorch', 'IPBan'].indexOf(r.request.button) != -1)
		{ /* Do Nothing */ }
		else if(r.request.button == 'Transfer logs')
		{
			if(r.logs)
			{
				var tradeBox = document.createElement('div');
				tradeBox.className = 'transfers';
				support.sptActResponse.appendChild(tradeBox);
				
				var tt = document.createElement('table');
				tt.style.width = '100%';
				tradeBox.appendChild(tt);
				
				tt.innerHTML = '<tr class="h"> <th> TO </th> <th> FROM </th> <th> XATS </th> <th> DAYS </th> <th> DATE </th> </tr>';
				for(var i in r.logs)
				{
					var tr = document.createElement('tr');
					tr.className = ['d', 'l'][i % 2];
					tr.innerHTML = '<th>' + r.logs[i]['to'] + '</th> <th>' + r.logs[i]['from'] + '</th> <th>' + r.logs[i]['xats'] + '</th> <th>' + r.logs[i]['days'] + '</th> <th>' + r.logs[i]['date'] + '</th>';
					tt.appendChild(tr);
				}
			}
		}
		else if(r.request.button == 'Close Ticket')
		{
			if(r.redirect)
			{
				setTimeout(
					function()
					{
						support.loadTickets();
					}, 2500
				);
			}
		}
		else if(r.request.button == 'Elevate to admin dept')
		{
			support.actView(r.request.tid);
		}
		else
		{
			$.notify(e);
		}
	},
	
	actButtonClick: function(e)
	{ // Done via _POST to avoid CSRF attacks ;)
		var supportActID = document.getElementById('supportActionId').value;
		
		if(supportActID.match(/[^\d]/))
		{
			$.notify("I asked you to enter their user ID, what's so hard about that?", 'warning');
		}
		else
		{
			support.coverShow();;
			support.POST('/support?ajax=buttonaction', 'button=' + encodeURIComponent(this.innerHTML) + '&uid=' + supportActID + '&tid=' + support.currentTicket.ticket.tid, support.actButtonClickResponse);
		}
	},
	
	actArchive: function(e)
	{
		var ticketNode = document.getElementById('ticketNode' + e);
		support.coverShow();
		
		support.GET('/support?ajax=archive&tid=' + e,
			function(e)
			{
				if(e == 1)
				{
					ticketNode.style.display = 'none';
					support.coverHide();
				}
				else
				{
					$.notify('Ticket Deletion Error - Please speak to an administrator', 'error');

					support.loadTickets();
				}
			}
		);
	},
	
	GET: function(url, callback)
	{
		support.xmlCall = callback;
		support.xmlHttp = new XMLHttpRequest();
		support.xmlHttp.onreadystatechange = support.XHChange;
		support.xmlHttp.open('GET', url, true);
		support.xmlHttp.send(null);
	},
	
	POST: function(url, params, callback)
	{
		support.xmlCall = callback;
		support.xmlHttp = new XMLHttpRequest();
		support.xmlHttp.onreadystatechange = support.XHChange;
		support.xmlHttp.open('POST', url, true);
		support.xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		support.xmlHttp.send(params);
	},
	
	XHChange: function()
	{
		if(support.xmlHttp.readyState == 4 && support.xmlHttp.status == 200)
		{
			support.xmlCall(support.xmlHttp.responseText);
		}
	},
	
	tsToDate: function(ts)
	{
		var a = new Date(ts * 1000);
		var month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][a.getMonth()];
		var year = a.getFullYear();
		var date = a.getDate();
		var hour = a.getHours();
		var min = a.getMinutes();
		var sec = a.getSeconds();
		var time = date + ', ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec;
		return time;
	}
}


if(document.readyState == "complete" || document.readyState == "loaded")
{ // Initiate if already loaded
	support.init();
}
else
{
	window.addEventListener(
		'DOMContentLoaded',
		function()
		{ // in case support.init isn't defined
			support.init();
		}
	);
}