$(document).ready(function(){
   $('#srch-btn').click(function(){
       $('#photos-panel').html("Loading...");
       $.ajax({
           url: "http://localhost:3000/home/tags?tag="+$('#hash-input').val(),
           dataType: 'json',
           success: function(data){
               $('#photos-panel').html("");
               for (var i = 0; i < data.length; i++){
                    $('#photos-panel').append(
                        $('<img>', {src: data[i]['images']['standard_resolution']['url']} )
                    );
               }
           },
           error: function(err){
               $('#photos-panel').html("Something went wrong:" + err);
           }
       });
   });
});