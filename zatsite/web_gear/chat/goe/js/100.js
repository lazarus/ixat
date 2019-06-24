function Load()
{ 
	var Txt = opener.document.getElementById("gi_100"); 
	document.getElementById("links").value = Txt.value;
}
function changeParent()
{
	var Txt = opener.document.getElementById("gi_100"); 
	Txt.value = document.getElementById("links").value;
	window.close();	 
}