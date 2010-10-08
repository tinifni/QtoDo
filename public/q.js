(function($){
  $(document).ready(function() {
    function locationBox(){
      $(".location").click(function(){
        var loc = $(this).text();
        var tn = $(this).parent().attr("id");
        $(this).replaceWith(selectLocation(tn));
        $("#location" + tn + " option[value='" + loc + "']").attr("selected", "selected");

        $("#location" + tn).change(function(){
          var loc = this.value;
          var tn = $(this).parent().parent().attr("id");
          $(this).parent().replaceWith(locationReturn(loc));
          $.post("/tns/" + tn + "/location", { location : loc }, function(){
            $("#flash").css({"background":"#333333","color":"white"});
            $("#flash").show();
            $("#flash").text("TN" + tn + " updated location: " + loc);
          });

          locationBox();
        });
      });
    }

    function statusBox(){
      $(".status").click(function(){
        var stat = $(this).text();
        var tn = $(this).parent().attr("id");
        $(this).replaceWith(selectStatus(tn));
        $("#status" + tn + " option[value='" + stat + "']").attr("selected", "selected");

        $("#status" + tn).change(function(){
          var stat = this.value;
          var tn = $(this).parent().parent().attr("id");
          $(this).parent().replaceWith(statusReturn(stat));
          $.post("/tns/" + tn + "/status", { status : stat }, function(){
            $("#flash").css({"background":"#333333","color":"white"});
            $("#flash").show();
            $("#flash").text("TN" + tn + " updated status: " + stat);
          });

          statusBox();
        });
      });
    }

    statusBox();
    locationBox();

    $("#flash").hide();
    $("#flash").click(function(){$("#flash").hide()});

    $(window).scroll(function(){$("#menu_float").animate({top:$(window).scrollTop()+"px"},{queue:false,duration:0})});

    function selectStatus(tn){
      return $("<td>")
        .attr({ "class" : "statusUpdate" })
        .append($("<select>")
          .attr({ "id" : "status" + tn })
          .append($("<option>").attr({ "value" : "" }).text(""))
          .append($("<option>").attr({ "value" : "Repair" }).text("Repair"))
          .append($("<option>").attr({ "value" : "Capture" }).text("Capture"))
          .append($("<option>").attr({ "value" : "ID" }).text("ID"))
          .append($("<option>").attr({ "value" : "QA" }).text("QA"))
          .append($("<option>").attr({ "value" : "Exec" }).text("Exec"))
          .append($("<option>").attr({ "value" : "Set" }).text("Set"))
          .append($("<option>").attr({ "value" : "Compliment" }).text("Compliment"))
          .append($("<option>").attr({ "value" : "Complete" }).text("Complete"))
        );
    }

    function statusReturn(stat){return $("<td>").attr({ "class" : "status" }).text(stat);}

    function selectLocation(tn){
      return $("<td>")
        .attr({ "class" : "locationUpdate" })
        .append($("<select>")
          .attr({ "id" : "location" + tn })
          .append($("<option>").attr({ "value" : "" }).text(""))
          .append($("<option>").attr({ "value" : "Bangalore" }).text("Bangalore"))
          .append($("<option>").attr({ "value" : "Cypress" }).text("Cypress"))
        );
    }

    function locationReturn(loc){return $("<td>").attr({ "class" : "location" }).text(loc);}
  });
})(jQuery);
