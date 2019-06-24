function Load()
{ 
	var Txt = opener.document.getElementById("gi_106"); 
	document.getElementById("gscol").value = Txt.value;
}
function changeParent()
{
	var Txt = opener.document.getElementById("gi_106"); 
	Txt.value = document.getElementById("gscol").value;
	window.close();	 
}