var Defaults = {'mg':'7','mb':'8','mm':'11','kk':'7','bn':'7','ubn':'7','mbt':'6','obt':'0','ssb':'99','cbs':'0','ss':'10','lkd':'0','rgd':'0','bst':'0','prm':'5','bge':'7','mxt':'10','ads':'0','sme':'7','dnc':'14','rl':'11','bdg':'10','ns':'7','yl':'7','rc':'7','rf':'6','p':'10','pd':'1','pt':'1','ka':'10','mft':'4','ft':'50','j':'2','js':'0','mmt':'1','cm':'11'};
var Min = {'mbt':'0','obt':'0','bst':'0','mxt':'1','ads':'0','rf':'0.1','pd':'1','pt':'0.1','mft':'1','ft':'10','js':'Array','mmt':'1', 0:0};
var Max = {'mbt':'99','obt':'999','bst':'4','mxt':'200','ads':'2','rf':'10','pd':'5','pt':'12','mft':'99','ft':'200','mmt':'99', 0:0};
  

function changeParent() {
    //var Txt = opener.document.getElementById('gi_80'); 
    //Txt.value = v;
    var o, i, j, idc = 0, b = 0;
    for (o in Defaults) {
        for (j = 0; j < 8; j++) {
            i = document.getElementById('idc_' + o + '_' + j);
            if (!i) break;
            idc = 1;
            if (i.checked) b |= (1 << j);
        }
        if (idc) {
            b = b & Max[o];
            if (b == Defaults[o])
                delete Defaults[o];
            else
                Defaults[o] = b;
            idc = 0;
        }
        i = document.getElementById('idt_' + o); // text
        if (i) {
            if (i.value == Defaults[o])
                delete Defaults[o];
            else
            if (!Max[o])
                Defaults[o] = i.value;
            else {
                Defaults[o] = parseFloat(i.value);
                if (isNaN(i.value)) delete Defaults[o];
                else
                if (Max[o]) {
                    if (Defaults[o] > parseFloat(Max[o])) Defaults[o] = Max[o];
                    if (Defaults[o] < parseFloat(Min[o])) Defaults[o] = Min[o];
                }
            }
        }
        i = document.getElementById('ids_' + o); // select
        if (i) {
            if (i[i.selectedIndex].value == Defaults[o])
                delete Defaults[o];
            else
                Defaults[o] = i[i.selectedIndex].value;
        }
    }
    //alert(JSON.stringify(Defaults));
    var Txt = opener.document.getElementById('gi_80');
    Txt.value = (JSON.stringify(Defaults));
    window.close();
}

escapeHTML = function(s) {
	return s.replace(/'/g, '&#039;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
};

unescapeHTML = function(s) {
	return s.replace(/&#039;/g, "'").replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"');
};

function Load() {
    var Txt = unescapeHTML(opener.document.getElementById('gi_80').value);
    //var Opts = JSON.parse('{"mg":10,"mb":10,"mm":14,"bn":7,"ubn":11,"kk":10,"mbt":3,"obt":10,"ss":14,"lkd":7,"rgd":3}'); 
    var Opts = JSON.parse(Txt);
    //alert("ZZZ"+z['mm']);
    var o, i, j;
    for (o in Defaults) {
        if (!Opts[o]) continue;
        for (j = 0; j < 8; j++) {
            i = document.getElementById('idc_' + o + '_' + j);
            if (!i) break;
            i.checked = Opts[o] & (1 << j);
        }
        i = document.getElementById('idt_' + o); // text
        if (i) {
            i.value = Opts[o];
        }
        i = document.getElementById('ids_' + o); // select
        if (i) {
            for (var n = 0; n < i.length; n++) {
                if (i[n].value == Opts[o])
                    i.selectedIndex = n;
            }
        }
    }
}

function setDefault() {
    var o, i, j;
    for (o in Defaults) {
        for (j = 0; j < 8; j++) {
            i = document.getElementById('idc_' + o + '_' + j);
            if (!i) break;
            i.checked = Defaults[o] & (1 << j);
        }
        i = document.getElementById('idt_' + o); // text
        if (i) {
            i.value = Defaults[o];
        }
        i = document.getElementById('ids_' + o); // select
        if (i) {
            for (var n = 0; n < i.length; n++) {
                if (i[n].value == Defaults[o])
                    i.selectedIndex = n;
            }
        }
    }
}