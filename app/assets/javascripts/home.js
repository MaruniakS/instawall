$(document).ready(function(){
    var hash_tags = [];
    var pagination = "";
   $('#srch-btn').click(function(){
       $('#photos-panel').html("Loading...");
       $.ajax({
           url: "http://localhost:3000/home/photos_by_tags?tag="+$('#hash-input').val(),
           dataType: 'json',
           success: function(data){
               hash_tags = data['hash_tags'];
               pagination = data['pagination'];
               data = data['photos'];
               $('#photos-panel').html("");
               for (var i = 0; i < data.length; i++){
                    $('#photos-panel').append(
                        $('<img>', {class: "img-thumbnail photos",src: data[i]['images']['standard_resolution']['url']} )
                    );
               }
           },
           error: function(err){
               $('#photos-panel').html("Something went wrong: " + err);
           }
       });
   });
});