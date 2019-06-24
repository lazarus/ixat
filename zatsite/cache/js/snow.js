var Snow = {
	canvas: null,
	ctx: null,
	particles: [],
	mp: 80,
	W: 0,
	H: 0,
	angle: 0,
	interval: null,
	initizlied: false,
	running: false,
	init: function snowInit() {
		if (Snow.initizlied)
			return false;
		if (window.localStorage.snowEnabled === undefined)
			window.localStorage.snowEnabled = "true";
		if (window.localStorage.snowEnabled !== "true")
			return false;
		if (document.getElementById("canvas") === null)
			return;
		Snow.canvas = document.getElementById("canvas");
		Snow.ctx = Snow.canvas.getContext("2d");
		Snow.recalc();
		Snow.particles = [];
		for (var i = 0; i < Snow.mp; i++) {
			Snow.particles.push({
				x: Math.random() * Snow.W,
				y: Math.random() * Snow.H,
				r: Math.random() * 4 + 1,
				d: Math.random() * Snow.mp
			})
		}
		window.addEventListener("resize", function() {
			clearTimeout(Snow.resizeTimer);
			Snow.resizeTimer = setTimeout(Snow.recalc, 100);
		});
		Snow.initizlied = true;
	},
	recalc: function snowRecalc() {
		Snow.W = window.innerWidth;
		Snow.H = window.innerHeight;
		Snow.canvas.width = Snow.W;
		Snow.canvas.height = Snow.H;
	},
	toggle: function snowToggle() {
		window.localStorage.snowEnabled = window.localStorage.snowEnabled === "true" ? "false" : "true";
		if (window.localStorage.snowEnabled === "true")
			Snow.start();
		else
			Snow.stop();
	},
	draw: function snowDraw() {
		if (!Snow.running) {
			return;
		}
		Snow.ctx.clearRect(0, 0, Snow.W, Snow.H);
		Snow.ctx.fillStyle = "rgba(255, 255, 255, 0.8)";
		Snow.ctx.beginPath();
		for (var i = 0; i < Snow.mp; i++) {
			var p = Snow.particles[i];
			Snow.ctx.moveTo(p.x, p.y);
			Snow.ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2, true);
		}
		Snow.ctx.fill();
		Snow.update();
		requestAnimationFrame(Snow.draw);
	},
	update: function snowUpdate() {
		Snow.angle += 0.01;
		for (var i = 0; i < Snow.mp; i++) {
			var p = Snow.particles[i];
			p.y += (Math.cos(Snow.angle + p.d) + 1 + p.r / 2) / 4;
			p.x += (Math.sin(Snow.angle) * 2) / 4;
			if (p.x > Snow.W + 10 || p.x < -10 || p.y > Snow.H) {
				if (i % 3 > 0) {
					Snow.particles[i] = {
						x: Math.random() * Snow.W,
						y: -20,
						r: p.r,
						d: p.d
					};
				} else {
					if (Math.sin(Snow.angle) > 0) {
						Snow.particles[i] = {
							x: -5,
							y: Math.random() * Snow.H,
							r: p.r,
							d: p.d
						};
					} else {
						Snow.particles[i] = {
							x: Snow.W + 5,
							y: Math.random() * Snow.H,
							r: p.r,
							d: p.d
						};
					}
				}
			}
		}
	},
	start: function snowStart() {
		Snow.init();
		if (!Snow.initizlied)
			return;
		if (Snow.running)
			return;
		Snow.interval = requestAnimationFrame(Snow.draw);
		Snow.running = true;
	},
	stop: function snowStop() {
		Snow.init();
		if (!Snow.initizlied)
			return;
		if (!Snow.running)
			return;
		Snow.ctx.clearRect(0, 0, Snow.W, Snow.H);
		Snow.running = false;
	}
};