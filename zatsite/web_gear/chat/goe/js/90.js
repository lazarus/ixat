function Load()
{ 
	var Txt = opener.document.getElementById("gi_90"); 
	document.getElementById("bad").value = Txt.value;
}
function changeParent()
{
	var Txt = opener.document.getElementById("gi_90"); 
	Txt.value = document.getElementById("bad").value;
	window.close();	 
}