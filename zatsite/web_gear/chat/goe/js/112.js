function Load()
{ 
	var Txt = opener.document.getElementById("gi_112"); 
	document.getElementById("announce").value = Txt.value;
}
function changeParent()
{
	var Txt = opener.document.getElementById("gi_112"); 
	Txt.value = document.getElementById("announce").value;
	window.close();	 
}