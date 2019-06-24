package
{
	import flash.display.MovieClip;

	public dynamic class chatter2 extends MovieClip
	{

		static const hat = 1;
		static const tmp = 2;
		static const Married = 4;
		static const BFF = 8;
		static const Married2 = 16;
		static const BFF2 = 32;
		static const Star = 64;
		static const Gag = 128;
		static const sinbin = 256;
		static const Behinds = Married | BFF;
		static const Fronts = Married2 | BFF2 | Star | Gag | sinbin | Single;
		static const Mob = 512;
		static const MBack = 1024;
		static const Glow = 2048;
		static const Single = 4096;
		static const flash = 8192;
		static const hat2 = 0x4000;

		var Options: int = 0;
		var flag0:int = 0;
		var flag2:int = 0;
		var Glowing: Boolean;
		var ColP1:int = 49152;
		var ColP2;
		var ColF:int;
		var ColB:int;
		var Size:int = 20;
		var Simple = true;
		var Pawn;
		var Pawn2;
		var Effect;
		var PawnOpts;
		var mc;

		public function chatter2() {
			super();
		}

		public function Go():* {
			var _local3:* = undefined;
			var _local4:* = undefined;
			var _local1:* = new Array();
			if(this.Options & Mob) {
				_local1.push("p1mob");
				this.Simple = false;
			} else if(this.Pawn)   {
				if(this.Pawn == "p1cyclepawn") {
					_local1.push("p1pwn");
					if(this.cyclepawn == undefined) {
						this.cyclepawn = "y";
					}
					_local1.push(this.cyclepawn);
				} else {
					_local1.push(this.Pawn);
					if(this.Pawn.substr(0, 2) != "p1") {
						_local1.push("offset");
						_local1.push("w5400");
					}
					if(this.Options & flash) {
						_local1.push("w1");
					}
				}
				this.Simple = false;
			} else {
				_local1.push("p1pwn");
			}
			if(this.Pawn2 && this.Pawn2 == "p1fade") {
				_local1.push("f");
				this.Simple = false;
			}
			_local1.push(this.d2h(this.ColP1));
			if(this.ColP2 != undefined && this.ColP1 != this.ColP2) {
				_local1.push(this.d2h(this.ColP2));
				this.Simple = false;
			}
			if(this.flag2 & 1) {
				_local1.push("mirror");
				_local1.push("shift1");
				_local1.push("w-11");
				this.Simple = false;
			}
			if(this.Options & Fronts) {
				_local1.push("frnt1");
				_local1.push("w" + (this.Options & Fronts));
				if(this.ColF) {
					_local1.push(this.d2h(this.ColF));
				}
				this.Simple = false;
			}
			if(this.Options & Behinds) {
				_local1.push("bff1");
				_local1.push("w" + (this.Options & Behinds));
				this.Simple = false;
			}
			if(this.flag0 & 262144 && this.Pawn != "p1badge") {
				_local1.push("badge1");
				_local1.push(this.d2h(this.ColP1));
				this.Simple = false;
			}
			if(this.flag0 & 524288 && this.Pawn != "p1naughty") {
				_local1.push("naughty1");
				if(this.flag2 & 1) {
					_local1.push("shift1");
				}
				this.Simple = false;
			}
			if(this.Hat && !(this.flag0 & 32768)) {
				//_local1.push("hat1");
				if ((this.Options & hat2)){
					_local1.push("hat3");
				} else {
					_local1.push("hat1");
				};
				_local1.push("w" + this.Hat);
				this.Simple = false;
			}
			//
			
			if (this.Pawn2 && this.Pawn2 == "p1flagpawn1" && !(this.flag0 & (0x4000 | 0x10000)) && !(this.Options & Fronts)) {
				_local1.push("flgpwn");
				_local1.push("w" + this.PawnOpts);
				this.Simple = false;
			}
			if (this.PawnOpts && this.Pawn2 != "p1flagpawn1") {
				_local1.push("Opts");
				_local1.push(this.PawnOpts);
			};
			//
			if(this.flag0 & 16384) {
				_local1.push("away");
				this.Simple = false;
			}
			if(this.flag0 & 32768) {
				_local1.push("dunce1");
				this.Simple = false;
			}
			if(this.flag0 & 1048576) {
				_local1.push("yellow1");
				this.Simple = false;
			}
			if(this.flag0 & 2097152) {
				_local1.push("red1");
				this.Simple = false;
			}
			if(this.flag0 & 65536) {
				_local1.push("typing");
				this.Simple = false;
			}
			if(this.Effect) {
				_local1.push(this.Effect);
				this.Simple = false;
			}
			if(this.doCycle == true) {
				_local1.push("y");
			}
			var _local2:* = "(" + _local1.join("#") + ")";
			
			if(_local2 == this.SA) {
				return;
			}
			this.SA = _local2;
			if(this.mc) {
				removeChild(this.mc);
				this.mc.cleanUp();
				this.mc = null;
			}
			if(!todo.bThin) {
				if(!this.Simple) {
					_local3 = cachedSprite.dic[this.SA];
					if(_local3) {
						_local3 = !_local3.Pending;
					}
				}
				if(!_local3 && !this.Pawn) {
					_local4 = new library("p1pwn");
					this.addChild(_local4);
					if(this.ColP1) {
						xatlib.McSetRGB(_local4.xitem.col0, this.ColP1);
					}
					if(this.Size != 20) {
						_local4.scaleX = _local4.scaleY = this.Size / 20;
					}
					if(this.flag2 & 1) {
						_local4.x = 10;
					}
				}
				if(this.Simple) {
					return;
				}
			}
			this.SF = 2;
			xmessage.PowSm(this, _local1, 19, todo.ALL_POWERS);
			this.mc = new smiley(this, _local1[0], this.Size);
		}

		private function d2h(param1 : int):String {
			var _local2:* = undefined;
			var _local3:String = "";
			var _local4:int = 0;
			while(_local4 < 6) {
				_local2 = param1 & 15;
				_local2 = String.fromCharCode(_local2 > 9 ? _local2 + 87 : _local2 + 48);
				param1 = param1 >> 4;
				_local3 = _local2 + _local3;
				_local4++;
			}
			return _local3;
		}
	}
}
