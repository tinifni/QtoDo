(function($){
	$(document).ready(function() {
		$(".location").click(function(){
			var loc = this.innerHTML;
			var tn = this.parentNode.getAttribute("id");
			$("#flash").css({"visibility":"visible","background":"silver","color":"white","font-weight":"bold"});
			$("#flash").text(loc + " " + tn);
			//$.post("/tns/" + tn + "/location", { location : loc }, function(){
				//$("#flash").css({"visibility":"visible","background":"silver","color":"white","font-weight":"bold"});
				//$("#flash").text("TN" + tn + " updated location: " + loc);
			//});
		});

		$(".status").click(function(){
			var stat = this.innerHTML;
			var tn = this.parentNode.getAttribute("id");
			var position = $("#" + tn).children(".status").position();
			$("#flash").css({"visibility":"visible","background":"silver","color":"white","font-weight":"bold"});
			$("#flash").text(stat + " " + tn);
			//$.post("/tns/" + tn + "/status", { status : stat }, function(){
				//$("#flash").css({"visibility":"visible","background":"silver","color":"white","font-weight":"bold"});
				//$("#flash").text("\u2713 TN" + tn + " updated status: " + stat);
			//});
		});

		$("#flash").click(function(){$("#flash").css("visibility","hidden")});
	});
})(jQuery);
