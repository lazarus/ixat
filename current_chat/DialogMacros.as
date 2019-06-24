package {
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
    import flash.net.*;
	import flash.utils.ByteArray;
	import com.adobe.serialization.json.xJSON;
	import com.adobe.serialization.json.*;
	import flash.system.System;
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.desktop.ClipboardTransferMode;

    public class DialogMacros extends Sprite {

        var mcmacrosbackground;
        var mcmacrosbackb;
        var mcmacrosback;
        var mcmacrosbackmask;
        var bmacrosscrollmc;
        var boutin;
        var Namefldbackground;
        var Namefld;
        var Messfldbackground;
        var Messfld;
		
		public var macrosinc;
		public var bpw;
        public var bph;
        public var bpx;
        public var bpy;
		public var mFileReference:FileReference;

        public function DialogMacros(){
            super();
            this.macrosinc = 0;
            this.boutin = false;
            this.mcmacrosbackground = new xDialog(this, xatlib.NX(20), xatlib.NY(20), xatlib.NX(600), xatlib.NY(440), " Macro Manager", undefined, 0, this.Delete);
            var Dialog:* = this.mcmacrosbackground.Dia;
			Dialog.mcimportmacro = new xBut(this.mcmacrosbackground, xatlib.NX(30), xatlib.NY(420), xatlib.NX(60), xatlib.NY(30), "Import", this.ImportMacros, 0x8000000);
			if(this.getMacroCount() > 0) {
				Dialog.mcexportmacro = new xBut(this.mcmacrosbackground, xatlib.NX(95), xatlib.NY(420), xatlib.NX(60), xatlib.NY(30), "Export", this.ExportMacros, 0x8000000);
				Dialog.mcsharemacro = new xBut(this.mcmacrosbackground, xatlib.NX(160), xatlib.NY(420), xatlib.NX(60), xatlib.NY(30), "Upload", this.ShareMacros, 0x8000000);
				Dialog.mcresetmacro = new xBut(this.mcmacrosbackground, xatlib.NX(434), xatlib.NY(420), xatlib.NX(80), xatlib.NY(30), "Reset", this.ResetMacros, 0x5000000);
			}
			Dialog.mcaddmacro = new xBut(this.mcmacrosbackground, xatlib.NX(524), xatlib.NY(420), xatlib.NX(80), xatlib.NY(30), "New", this.MacroEditor, 0x5000000);
			Dialog.mcaddmacro.mode = 3;
            Dialog.mcclose = new xBut(Dialog, xatlib.NX(240), xatlib.NY(420), xatlib.NX(160), xatlib.NY(30), xconst.ST(45), this.macrosClose);
            this.bpw = xatlib.NX(580);
            this.bph = (xatlib.NY((390 - 30)) - 40);
            this.bpx = xatlib.NX(30);
            this.bpy = (xatlib.NY((20 + 25)) + 40);
            this.mcmacrosbackb = xatlib.AddBackground(this.mcmacrosbackground, this.bpx, this.bpy, this.bpw, this.bph);
            this.mcmacrosback = new MovieClip();
            this.mcmacrosbackb.addChild(this.mcmacrosback);
            this.mcmacrosback.Width = this.bpw;
            this.mcmacrosbackmask = xatlib.AddBackground(this.mcmacrosbackground, (this.bpx + 1), (this.bpy + 1), ((this.bpw - 2) - xatlib.NX(16)), (this.bph - 2), xatlib.c_Mask);
            this.mcmacrosback.mask = this.mcmacrosbackmask;
            this.bmacrosscrollmc = new xScroll(this.mcmacrosbackground, ((this.bpx + this.bpw) - xatlib.NX(16)), this.bpy, xatlib.NX(16), this.bph, xatlib.NX(16), xatlib.NX(32), 30, (10 * 100), (0 * 100), this.onmacrosScrollChange);
			if(this.getMacroCount() > 0){ 
				for (var macro in todo.Macros) {
					AddMacro(macro);
				};
			} else {
				var mc:MovieClip = new MovieClip();
				this.mcmacrosbackground.addChild(mc);
				mc.x = 0;
				mc.y = 60;
				xmessage.AddMessageToMc(mc, 1, "You don't have any macros set.", 30, (this.mcmacrosbackground.Width - 30), 0, todo.w_userno);
			}
        }

        function Delete() : void
		{
            main.hint.HintOff();
            if (!this.mcmacrosbackground){
                return;
            };
            this.mcmacrosbackground.Delete();
            this.mcmacrosbackb.removeChild(this.mcmacrosback);
            this.mcmacrosback = null;
            this.mcmacrosbackground = null;
            main.closeDialog();
        }
        function AddMacro(macro:String) : void
		{
            var mc:MovieClip = new MovieClip();
            this.mcmacrosback.addChild(mc);
            mc.x = 5;
            var minc:Number = (8 + xmessage.AddMessageToMc(mc, 1, "$" + macro + " = " + todo.Macros[macro], xatlib.NX(30), xatlib.NY(this.mcmacrosback.Width - 30), xatlib.NY(this.macrosinc), todo.w_userno));
			mc.edit = new xBut(mc, xatlib.NX(0), xatlib.NY(this.macrosinc + 6), xatlib.NX(25), xatlib.NY(15), "Edit", this.MacroEditor, 0x3500000);
			mc.edit.m = macro;
			mc.edit.mode = 0;
			this.macrosinc = (this.macrosinc + minc);
        }
        function onmacrosScrollChange() : void
		{
            var size:Number = ((this.macrosinc - this.bph) + 4);
            if (size < 0){
                size = 0;
            };
            this.bmacrosscrollmc.Scr_size = size;
            var pos:Number = this.bmacrosscrollmc.Scr_position;
            this.mcmacrosback.y = -(pos);
        }
		
        function macrosClose(e:MouseEvent=undefined) : void
		{
            this.Delete();
		}
		
		function ResetMacros(e:Event) : void
		{
			for (var macro in todo.Macros) {
				delete todo.Macros[macro];
			};
			xatlib.MainSolWrite("Macros", todo.Macros);
			xatlib.GeneralMessage("Macro Manager", "You have successfully reseted your macros.");
			main.openDialog(12);
		}
		
		function ImportFromFile(e:Event) : void
		{
			main.box_layer.mcImportMacros.Delete();
			mFileReference = new FileReference();
			mFileReference.addEventListener(Event.SELECT, onFileSelected);
			mFileReference.addEventListener(Event.CANCEL, onImportCanceled);
			var csvTypeFilter:FileFilter = new FileFilter("XATM File","*.xatm");
			mFileReference.browse([csvTypeFilter]);
		}
		
		
		function ImportFromUrl(e:Event) : void
		{
			xatlib.GeneralMessage("Import Macros", 'Import from url disabled for now');
			main.box_layer.mcImportMacros.Delete();
			return;
			var match = this.Namefld.text.match(/^https:\/\/(?:www\.)?hastebin\.com(?:\/.*)?$/g);
			if (match) {
				match[0] = match[0].indexOf("/documents/") >= 0 ? match[0] : match[0].replace('.com/', '.com/documents/');
				var Request = new URLRequest();
				Request.url = match[0];
				Request.method = URLRequestMethod.GET;
				var loader = new URLLoader();
				loader.load(Request);
				loader.addEventListener(Event.COMPLETE, this.onUrlLoaded);
				main.box_layer.mcImportMacros.Delete();
			} else {
				xatlib.GeneralMessage("Import Macros", 'Invalid url');
			}
		}
		
		function onUrlLoaded(e:Event) {
			var loader:URLLoader = URLLoader(e.target);
			var json:* = xJSON.decode(loader.data);
			if (json.key && json.data) {
				var success:Boolean = false;
				var hasStatus:Boolean = false;
				var str:String = json.data.toString();
				var hasError:Number = 0;
				if(str.length > 0) {
					var lines:Array = str.split("\n");
					if(lines.length > 0) {
						for(var line in lines) {
							var macro:Array = lines[line].split("=", 2);
							// Check for empty var/value and misformed
							if(macro.length == 2){ 
								if (macro[0].substr(0, 1) == "$") {
									macro[0] = macro[0].substr(1);
								}
								macro[0] = macro[0].replace("<", "&lt;");
								macro[1] = macro[1].replace("<", "&lt;");
								if (macro[0].length > 0 && macro[1].length > 0){
									if (todo.Macros == undefined){
										todo.Macros = new Object();
									}
									todo.Macros[macro[0]] = macro[1];
									switch (macro[0]) {
										case "status":
											xatlib.ReLogin();//hasStatus = true;
											break;
										case "sline":
											chat.mainDlg.UpdateEmotes();
											break;
										case "mark":
											xconst.MakeBads();
											break;
									}
								} else {
									hasError++;
								}
							} else {
								hasError++;
							}
						}
						success = true;
					}
				} 
				
				if(success) {
					if(hasError > 0) {
						xatlib.GeneralMessage("Macro Manager", hasError + " out of " + lines.length + " macros were unable to process.");
					} else {
						xatlib.GeneralMessage("Macro Manager", "You have successfully imported your macros.");
					}
					xatlib.MainSolWrite("Macros", todo.Macros);
					if(hasStatus) {
						xatlib.ReLogin();
					}
				} else {
					xatlib.GeneralMessage("Macro Manager", "There was problems processing your macros.");
				}
				main.box_layer.mcImportMacros.Delete();
				main.openDialog(12);
			}
		}
		
		function ImportMacros(e:Event) : void
		{
			main.box_layer.mcImportMacros = new xDialog(main.box_layer, xatlib.NX(80), xatlib.NY(160), xatlib.NX(480), xatlib.NY(125), "Import Macros", undefined, 0, ImportMacrosClose);
            var YY:Number = xatlib.NY(main.box_layer.mcImportMacros.DiaBack.y + 42);
            var Dialog:* = main.box_layer.mcImportMacros.Dia;
			var WW = main.box_layer.mcImportMacros.DiaBack.width;
			Dialog.txt1 = new MovieClip();
            Dialog.addChild(Dialog.txt1);
			xatlib.createTextNoWrap(Dialog.txt1, xatlib.NX((70 + 24)), xatlib.NY(YY), xatlib.NX(100), xatlib.NY(32), "Url:", 0x202020, 0, 100, 0, xatlib.NX(20), "left", 1);
			this.Namefldbackground = xatlib.AddBackground(Dialog, xatlib.NX((160)), xatlib.NY(YY), xatlib.NX(350), xatlib.NY(32));
            this.Namefld = xatlib.AddTextField(this.Namefldbackground, xatlib.NX(0), xatlib.NY(6), xatlib.NX(350), xatlib.NY(32));
            this.Namefld.type = TextFieldType.INPUT;
			this.Namefld.text = "";
			YY = YY + 45;
			main.box_layer.mcImportMacros.FromFile = new xBut(Dialog, xatlib.NX((WW/2)), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), "From File", ImportFromFile, 0x5000000);
			main.box_layer.mcImportMacros.FromUrl = new xBut(Dialog, xatlib.NX((WW/2) + 90), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), "From Url", ImportFromUrl, 0x5000000);
		}	

        function ImportMacrosClose(_arg_1:MouseEvent=undefined) : void
		{
            if (!main.box_layer.mcImportMacros){
                return;
            };
            main.box_layer.mcImportMacros.Delete();
        }	

		function ExportMacros(e:Event) : void
		{
			var macroArray:Array = new Array();
			for (var macro in todo.Macros) {
				macroArray.push("$" + macro + "=" + todo.Macros[macro]);
			}; 
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(macroArray.join("\n"));
			
			mFileReference = new FileReference();
			mFileReference.addEventListener(Event.CANCEL, onExportCanceled);
			mFileReference.addEventListener(Event.COMPLETE, onFileSaved);
			mFileReference.save(ba, 'macros.xatm');
		}
		function ShareMacros(e:Event) : void
		{
			var macroArray:Array = new Array();
			for (var macro in todo.Macros) {
				macroArray.push("$" + macro + "=" + todo.Macros[macro]);
			}; 
			
			var reqHead:URLRequestHeader = new URLRequestHeader("Content-type", "application/json");
            var req:URLRequest = new URLRequest("https://hastebin.com/documents");
            req.requestHeaders.push(reqHead);
            req.method = URLRequestMethod.POST;
            req.data = macroArray.join("\n");
            var loader:URLLoader = new URLLoader();
            loader.load(req);
			loader.addEventListener(Event.COMPLETE, this.PostCallback);
		}
		
        public function PostCallback(_arg_1:*){
			var data = xJSON.decode(_arg_1.currentTarget.data);
			if (data['key']) {
				xatlib.UrlPopup("hastebin.com", "https://hastebin.com/" + data['key']);
			} else {
				xatlib.GeneralMessage("Macro Manager", 'Failed to post to hastebin');
			}
        }
		
		function getMacroCount() : Number
		{
			//for some reason todo.macros.length is incorrect
			var i:Number = 0;
			if (todo.Macros != undefined){
				for (var macro in todo.Macros) {
					i++;
				};
			}
			return i;
		}
		
		function onImportCanceled(e:Event):void
		{
			xatlib.GeneralMessage("Macro Manager", "You have canceled the import.");
		}
		
		function onExportCanceled(e:Event):void
		{
			xatlib.GeneralMessage("Macro Manager", "You have canceled the export.");
		}
		
		function onFileSelected(e:Event):void
		{
			mFileReference.addEventListener(Event.COMPLETE, onFileLoaded);
			mFileReference.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
			mFileReference.load();
		}
 
		function onFileSaved(e:Event):void
		{
			xatlib.GeneralMessage("Macro Manager", "You have successfully exported your macros.");
			main.openDialog(12);
		}
		
		function onFileLoaded(e:Event):void
		{
			var success:Boolean = false;
			var hasStatus:Boolean = false;
			var fileReference:FileReference=e.target as FileReference;
			var data:ByteArray=fileReference["data"];
			var str:String = data.toString();
			var hasError:Number = 0;
			if(str.length > 0) {
				var lines:Array = str.split("\n");
				if(lines.length > 0) {
					for(var line in lines) {
						var macro:Array = lines[line].split("=", 2);
						// Check for empty var/value and misformed
						if(macro.length == 2){ 
							if (macro[0].substr(0, 1) == "$") {
								macro[0] = macro[0].substr(1);
							}
							macro[0] = macro[0].replace("<", "&lt;");
							macro[1] = macro[1].replace("<", "&lt;");
							if (macro[0].length > 0 && macro[1].length > 0){
								if (todo.Macros == undefined){
									todo.Macros = new Object();
								}
								todo.Macros[macro[0]] = macro[1];
								switch (macro[0]) {
									case "status":
										xatlib.ReLogin();//hasStatus = true;
										break;
									case "sline":
										chat.mainDlg.UpdateEmotes();
										break;
									case "mark":
										xconst.MakeBads();
										break;
								}
							} else {
								hasError++;
							}
						} else {
							hasError++;
						}
					}
					success = true;
				}
			} 
			
			mFileReference.removeEventListener(Event.COMPLETE, onFileLoaded);
			mFileReference.removeEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
			if(success) {
				if(hasError > 0) {
					xatlib.GeneralMessage("Macro Manager", hasError + " out of " + lines.length + " macros were unable to process.");
				} else {
					xatlib.GeneralMessage("Macro Manager", "You have successfully imported your macros.");
				}
				xatlib.MainSolWrite("Macros", todo.Macros);
				if(hasStatus) {
					xatlib.ReLogin();
				}
			} else {
				xatlib.GeneralMessage("Macro Manager", "There was problems processing your macros.");
			}
			main.openDialog(12);
		}
 
		function onFileLoadError(e:Event) : void
		{
			mFileReference.removeEventListener(Event.COMPLETE, onFileLoaded);
			mFileReference.removeEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
			
			xatlib.GeneralMessage("Macro Manager", "Your macro import has failed.");
			main.openDialog(12);
		}
		
		function MacroEditor(e:Event) : void
		{
			var targ = e.currentTarget;
			main.box_layer.mcEditMacro = new xDialog(main.box_layer, xatlib.NX(60), xatlib.NY(100), xatlib.NX(520), xatlib.NY(270), "Macro Editor", undefined, 0, EditMacroClose);
            var YY:Number = xatlib.NY(main.box_layer.mcEditMacro.DiaBack.y + 32);
            var Dialog:* = main.box_layer.mcEditMacro.Dia;

			Dialog.txt1 = new MovieClip();
            Dialog.addChild(Dialog.txt1);
			xatlib.createTextNoWrap(Dialog.txt1, xatlib.NX((50 + 24)), xatlib.NY(YY), xatlib.NX(100), xatlib.NY(32), "Macro name:", 0x202020, 0, 100, 0, xatlib.NX(20), "left", 1);
			this.Namefldbackground = xatlib.AddBackground(Dialog, xatlib.NX((160 + 24)), xatlib.NY(YY), xatlib.NX(370), xatlib.NY(32));
            this.Namefld = xatlib.AddTextField(this.Namefldbackground, xatlib.NX(0), xatlib.NY(6), xatlib.NX(370), xatlib.NY(32));
            this.Namefld.type = TextFieldType.INPUT;
			this.Namefld.text = targ.mode == 3 ? "":targ.m;
			
			YY = YY + 35;
			xatlib.createTextNoWrap(Dialog.txt1, xatlib.NX((50 + 24)), xatlib.NY(YY), xatlib.NX(100), xatlib.NY(32), "Macro text:", 0x202020, 0, 100, 0, xatlib.NX(20), "left", 1);
            this.Messfldbackground = xatlib.AddBackground(Dialog, xatlib.NX((160 + 24)), xatlib.NY(YY), xatlib.NX(370), xatlib.NY(32 + 100));
            this.Messfld = xatlib.AddTextField(this.Messfldbackground, xatlib.NX(0), xatlib.NY(6), xatlib.NX(370), xatlib.NY(32 + 100));
            this.Messfld.type = TextFieldType.INPUT;
			this.Messfld.wordWrap = true;
			this.Messfld.multiline = true;
			this.Messfld.text = targ.mode == 3 ? "":todo.Macros[targ.m];
			YY = YY + 45;
			if(targ.mode < 3) {
				main.box_layer.mcEditMacro.Save = new xBut(Dialog, xatlib.NX(190), xatlib.NY(330), xatlib.NX(120), xatlib.NY(30), "Save", EditMacro);
				main.box_layer.mcEditMacro.Save.m = targ.m;
				main.box_layer.mcEditMacro.Save.mode = 1;
				
				main.box_layer.mcEditMacro.Remove = new xBut(Dialog, xatlib.NX(140 + 190), xatlib.NY(330), xatlib.NX(120), xatlib.NY(30), "Remove", EditMacro);
				main.box_layer.mcEditMacro.Remove.m = targ.m;
				main.box_layer.mcEditMacro.Remove.mode = 2;
				
				if(todo.Macros[targ.m].toLowerCase() == "off") {
					main.box_layer.mcEditMacro.On = new xBut(Dialog, xatlib.NX((50 + 24)), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), "On", EditMacro);
					main.box_layer.mcEditMacro.On.m = targ.m;
					main.box_layer.mcEditMacro.On.mode = -1;
				} else if(todo.Macros[targ.m].toLowerCase() == "on") {
					main.box_layer.mcEditMacro.Off = new xBut(Dialog, xatlib.NX((50 + 24)), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), "Off", EditMacro);
					main.box_layer.mcEditMacro.Off.m = targ.m;
					main.box_layer.mcEditMacro.Off.mode = -2;
				} else {
					main.box_layer.mcEditMacro.On = new xBut(Dialog, xatlib.NX((50 + 24)), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), "On", EditMacro);
					main.box_layer.mcEditMacro.On.m = targ.m;
					main.box_layer.mcEditMacro.On.mode = -1;
					YY = YY + 35;
					main.box_layer.mcEditMacro.Off = new xBut(Dialog, xatlib.NX((50 + 24)), xatlib.NY(YY), xatlib.NX(80), xatlib.NY(30), "Off", EditMacro);
					main.box_layer.mcEditMacro.Off.m = targ.m;
					main.box_layer.mcEditMacro.Off.mode = -2;
				}
			} else {
				main.box_layer.mcEditMacro.New = new xBut(Dialog, xatlib.NX(70 + 190), xatlib.NY(330), xatlib.NX(120), xatlib.NY(30), "Create", EditMacro);
				main.box_layer.mcEditMacro.New.mode = 3;
			}
		}
		
		function EditMacro(e:Event) : void
		{
			var targ = e.currentTarget;
			if(targ.mode < 3){
				delete todo.Macros[targ.m];
			}
			if(targ.mode != 2 && targ.mode > 0) {
				delete todo.Macros[this.Namefld.text];
				this.Namefld.text = this.Namefld.text.replace("<", "&lt;");
				this.Messfld.text = this.Messfld.text.replace("<", "&lt;");
				// Remove empty edits
				if(this.Namefld.text.length > 0 && this.Messfld.text.length > 0) {
					todo.Macros[this.Namefld.text] = this.Messfld.text;
				}
			}
			if(targ.mode < 0) {
				todo.Macros[targ.m] = targ.mode == -1 ? "on":"off";
			}
			xatlib.MainSolWrite("Macros", todo.Macros);		
			main.box_layer.mcEditMacro.Delete();
			switch (targ.m) {
				case "status":
					xatlib.ReLogin();
					break;
				case "sline":
					chat.mainDlg.UpdateEmotes();
					break;
				case "mark":
					xconst.MakeBads();
					break;
				default:
					main.openDialog(12);
					break;
			}
		}				

        function EditMacroClose(_arg_1:MouseEvent=undefined) : void
		{
            if (!main.box_layer.mcEditMacro){
                return;
            };
            main.box_layer.mcEditMacro.Delete();
        }	

    }
	
}

