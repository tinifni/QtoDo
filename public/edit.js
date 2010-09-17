(function($){
	$(document).ready(function() {
		$(".location").change(function(){
			var loc = this.childNodes[1].value;
			var tn = this.parentNode.getAttribute("id");
			$.post("/tns/" + tn + "/location", { location : loc }, function(){
				$("#flash").css({"visibility":"visible","background":"silver","color":"white","font-weight":"bold"});
				$("#flash").text("TN" + tn + " updated location: " + loc);
			});
		});

		$(".status").change(function(){
			var stat = this.childNodes[1].value;
			var tn = this.parentNode.getAttribute("id");
			$.post("/tns/" + tn + "/status", { status : stat }, function(){
				$("#flash").css({"visibility":"visible","background":"silver","color":"white","font-weight":"bold"});
				$("#flash").text("TN" + tn + " updated status: " + stat);
			});
		});

		$("#flash").click(function(){$("#flash").css("visibility","hidden")});
	});
})(jQuery);
