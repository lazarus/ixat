function Load()
{ 
	var Txt = opener.document.getElementById("gi_150"); 
	document.getElementById("bot").value = Txt.value;
}
function changeParent()
{
	var Txt = opener.document.getElementById("gi_150"); 
	Txt.value = document.getElementById("bot").value;
	window.close();	 
}