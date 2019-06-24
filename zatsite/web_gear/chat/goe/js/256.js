 var Defaults = {'rnk':'3','dt':'60','rt':'10','rc':'0','tg':'2000','pz':''};
var Min = {'dt':'10','rt':'10','rc':'Array','tg':'100','pz':'', 0:0};
var Max = {'dt':'43200','rt':'600','tg':'1000000', 0:0};
  
 function changeParent(){
	 //var Txt = opener.document.getElementById('gi_256'); 
	 //Txt.value = v;
	 var o, i, j, idc=0, b=0;
	 for (o in Defaults)
	 {
		for(j=0; j<8; j++)
		{
			i = document.getElementById('idc_'+o+'_'+j);
			if(!i) break;
			idc=1;
			if(i.checked) b |= (1<<j);
		}
		if(idc)
		{
			b = b & Max[o];
			if(b == Defaults[o])
				delete Defaults[o];
			else
				Defaults[o] = b;				
			idc=0;
		}
	 	i = document.getElementById('idt_'+o); // text
		if(i) 
		{
			if(i.value == Defaults[o]) 
				delete Defaults[o];
			else
			if(!Max[o])
				Defaults[o] = i.value;
			else
			{
				Defaults[o] = parseFloat(i.value);
				if(isNaN(i.value)) delete Defaults[o];
				else
				if(Max[o])
				{
					if(Defaults[o] > parseFloat(Max[o])) Defaults[o] = Max[o];
					if(Defaults[o] < parseFloat(Min[o])) Defaults[o] = Min[o];
				}				
			}
		}
	 	i = document.getElementById('ids_'+o); // select
		if(i) 
		{
			if(i[i.selectedIndex].value == Defaults[o])
				delete Defaults[o];
			else
				Defaults[o] = i[i.selectedIndex].value;
		}
	}
	 //alert(JSON.stringify(Defaults));
	 var Txt = opener.document.getElementById('gi_256'); 
	Txt.value = (JSON.stringify(Defaults));
	window.close();	 
 }
 
 escapeHTML = function(s) {
  return s.replace(/"/g, '&quot;');
};

 function Load(){
	 var Txt = opener.document.getElementById('gi_256'); 
	 //var Opts = JSON.parse('{"mg":10,"mb":10,"mm":14,"bn":7,"ubn":11,"kk":10,"mbt":3,"obt":10,"ss":14,"lkd":7,"rgd":3}'); 
	 var Opts = JSON.parse(Txt.value); 
	 //alert("ZZZ"+z['mm']);
	 var o, i, j;
	 for (o in Defaults)
	 {
		if(!Opts[o]) continue;
		for(j=0; j<8; j++)
		{
			i = document.getElementById('idc_'+o+'_'+j);
			if(!i) break;
			i.checked = Opts[o] & (1<<j);
		}
		i = document.getElementById('idt_'+o); // text
		if(i) 
		{
			i.value = Opts[o];
		}
	 	i = document.getElementById('ids_'+o); // select
		if(i) 
		{
			for(var n = 0; n < i.length;  n++) 
			{
   				if(i[n].value == Opts[o])
    				 i.selectedIndex = n;
			}
		}
	}
 }
 
 function setDefault(){
	 var o, i, j;
	 for (o in Defaults)
	 {
		for(j=0; j<8; j++)
		{
			i = document.getElementById('idc_'+o+'_'+j);
			if(!i) break;
			i.checked = Defaults[o] & (1<<j);
		}
	 	i = document.getElementById('idt_'+o); // text
		if(i) 
		{
			i.value = Defaults[o];
		}
	 	i = document.getElementById('ids_'+o); // select
		if(i) 
		{
			for(var n = 0; n < i.length;  n++) 
			{
   				if(i[n].value == Defaults[o])
    				 i.selectedIndex = n;
			}
		}
	}
 }
