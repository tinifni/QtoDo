(function($){
  $(document).ready(function() {
    function locationBox(){
      $(".location").click(function(){
        var loc = $(this).text();
        var id = $(this).parent().attr("id");
        $(this).replaceWith(selectLocation(id));
        $("#location" + id + " option[value='" + loc + "']").attr("selected", "selected");

        $("#location" + id).change(function(){
          var loc = this.value;
          var id = $(this).parent().parent().attr("id");
          var tn = $(this).parent().parent().attr("data-tn");
          $(this).parent().replaceWith(locationReturn(loc));
          $.post("/tns/id/" + id + "/location", { location : loc }, function(){
            $("#flash").css({"background":"#333333","color":"white"});
            $("#flash").show();
            $("#flash").text("TN" + tn + " updated location: " + loc);
          });

          locationBox();
        });
      });
    }

    $("tr.row").hover(
      function(){
        var offset = $(this).offset();
        var id = $(this).attr("id");
        var tn = $(this).attr("data-tn");
        var idUrl = "/tns/id/" + id;
        $("<div id='delete" + id + "'></div>").css({
              "background-image" : "url('/delete.png')",
              "position": "absolute",
              "height": "16px",
              "width": "16px",
              "margin-top": "3px"
            }).offset({ top: offset.top + $(document).scrollTop(), left: offset.left - 16 })
            .appendTo($(this)).hover(
              function(){ $(this).css("background-position", "0 -16px")},
              function(){ $(this).css("background-position", "0 0")}
            ).click(function(){
              $("<div></div>").appendTo($(this)).dialog({
                resizable: false,
                title: "Delete TN" + tn + "?",
                height: 140,
                modal: true,
                buttons: {
                  "Delete": function() {
                    $("#" + id).hide();
                    $.post("/tns/id/" + id + "/destroy", function(){
                        $("#flash").css({"background":"#333333","color":"white"});
                        $("#flash").show();
                        $("#flash").text("TN" + tn + " has been deleted");
                    });
                    $(this).dialog("close");
                  },
                  Cancel: function() {
                    $(this).dialog("close");
                  }
                }
              });
            });
      },
      function(){
        var id = $(this).attr("id");
        $("#delete" + id).remove();
      }
    );

    function statusBox(){
      $(".status").click(function(){
        var stat = $(this).text();
        var id = $(this).parent().attr("id");
        $(this).replaceWith(selectStatus(id));
        $("#status" + id + " option[value='" + stat + "']").attr("selected", "selected");

        $("#status" + id).change(function(){
          var stat = this.value;
          var id = $(this).parent().parent().attr("id");
          var tn = $(this).parent().parent().attr("data-tn");
          $(this).parent().replaceWith(statusReturn(stat));
          $.post("/tns/id/" + id + "/status", { status : stat }, function(){
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

    function selectStatus(id){
      return $("<td>")
        .attr({ "class" : "statusUpdate" })
        .append($("<select>")
          .attr({ "id" : "status" + id })
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

    function selectLocation(id){
      return $("<td>")
        .attr({ "class" : "locationUpdate" })
        .append($("<select>")
          .attr({ "id" : "location" + id })
          .append($("<option>").attr({ "value" : "" }).text(""))
          .append($("<option>").attr({ "value" : "Bangalore" }).text("Bangalore"))
          .append($("<option>").attr({ "value" : "Cypress" }).text("Cypress"))
        );
    }

    function locationReturn(loc){return $("<td>").attr({ "class" : "location" }).text(loc);}
  });
})(jQuery);
