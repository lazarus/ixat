function Load()
{ 
	var Txt = opener.document.getElementById("gi_130"); 
	document.getElementById("gback").value = Txt.value;
}
function changeParent()
{
	var Txt = opener.document.getElementById("gi_130"); 
	Txt.value = document.getElementById("gback").value;
	window.close();	 
}