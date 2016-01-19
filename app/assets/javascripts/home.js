$(document).ready(function(){
    var hash_tags = [];
    var pagination = "";
   $('#srch-btn').click(function(){
       $('#photos-panel').html("Loading...");
       //$('#photos-panel').append($('<img>', {src: "../../../public/loading.gif"}));
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

    $(window).scroll(function()
    {
        if($(window).scrollTop() == $(document).height() - $(window).height())
        {
            if ('min_tag_id' in pagination){
                if (!$('#loading').length){
                    $('#photos-panel').append($('<div>', {id: 'loading', text: 'Loading...', style: "margin-top: 20px"}));
                }
                $.ajax({
                    url: "http://localhost:3000/home/load_more?tag="+hash_tags[0]+"&min_tag_id="+pagination['min_tag_id'],
                    dataType: 'json',
                    success: function(data)
                    {
                        $('#loading').remove();
                        for (var i = 0; i < data.length; i++){
                            $('#photos-panel').append(
                                $('<img>', {class: "img-thumbnail photos",src: data[i]['images']['standard_resolution']['url']} )
                            );
                        }

                    },
                    error: function(err){
                        $('#photos-panel').append("Something went wrong: " + err);
                    }
                });
            }
            else{
                hash_tags.shift();
                if (hash_tags.count === 0){
                    alert("hello");
                }
            }

        }
    });
});