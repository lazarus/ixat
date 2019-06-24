function Load()
{ 
	var Txt = opener.document.getElementById("gi_74"); 
	document.getElementById("gline").value = Txt.value;
}
function changeParent()
{
	var Txt = opener.document.getElementById("gi_74"); 
	Txt.value = document.getElementById("gline").value;
	window.close();	 
}