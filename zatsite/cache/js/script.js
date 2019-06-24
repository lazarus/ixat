'use strict';

$(function() {
	ixat.config({
		googleAnalyticsId: 'UA-23603180-2',
		smoothScroll: true
	});
	/*
	|--------------------------------------------------------------------------
	| Powers Page
	|--------------------------------------------------------------------------
	*/
	if (typeof onJQueryLoaded !== "undefined") {
		onJQueryLoaded();
	}
	/*
	|--------------------------------------------------------------------------
	| Dark Mode
	|--------------------------------------------------------------------------
	*/
	if ((typeof Snow !== "undefined" || Cookies.get("dark-mode") == "true") && Cookies.get("loginKey") != null && !document.location.pathname.includes("/landing")) {
		goDark();
	}

	function goDark() {
		var things = ["card",
			"text",
			"countdown",
			"social",
			"logo",
			"topbar",
			"section",
			"header",
			"bg",
			"thead",
			"table",
			"navbar"
		];
		if (typeof Snow !== "undefined" || Cookies.get("dark-mode") == "true") {
			$("[class*=inverse").addClass("was-inverse");
			things.forEach((thing) => {
				$("." + thing).addClass(thing + "-inverse")
			});
			$("form").addClass("form-glass");
			$(".bg-primary").removeClass("bg-primary").addClass("bg-inverse").addClass("was-primary");
			$(".bg-gray").removeClass("bg-gray").addClass("bg-inverse").addClass("was-gray");
			$(".table-striped").removeClass("table-striped").addClass('was-striped');
			$(".table-hover").removeClass("table-hover").addClass("was-hover");
		} else {
			things.forEach((thing) => {
				if ($("." + thing).hasClass("was-inverse"))
					$("." + thing).removeClass("was-inverse");
				else
					$("." + thing).removeClass(thing + "-inverse")
			});
			$("form").removeClass("form-glass");
			$(".was-gray").removeClass("bg-inverse").addClass("bg-gray");
			$(".was-primary").removeClass("bg-inverse").addClass("bg-primary");
			$(".was-striped").removeClass("was-striped").addClass("table-striped");
			$(".was-hover").removeClass("was-hover").addClass("table-hover");
		}
	}

	$(".dark-mode").click(function() {
		Cookies.set("dark-mode", Cookies.get("dark-mode") == "true" ? false : true, { expires: 365 });
		goDark();
	});
	/*
	|--------------------------------------------------------------------------
	| Snow
	|--------------------------------------------------------------------------
	*/
	if(typeof Snow !== "undefined") {
		Snow.start();
	}
});