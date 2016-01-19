$(document).ready(function(){
    var hash_tags = [];
    var pagination = "";
    function appendPhotos(data){
        if ('hash_tags' in data){
            hash_tags = data['hash_tags'];
        }
        pagination = data['pagination'];
        data = data['photos'];
        for (var i = 0; i < data.length; i++){
            $('#photos-panel').append(
                $('<img>', {class: "img-thumbnail photos",src: data[i]['images']['standard_resolution']['url']} )
            );
        }
    }
   $('#srch-btn').click(function(){
       $('#photos-panel').html("Loading...");
       var tags_string = $('#hash-input').val();
       hash_tags = tags_string.split(/[# ]/).filter(Boolean);
       //$('#photos-panel').append($('<img>', {src: "../../../public/loading.gif"}));
       $.ajax({
           url: "http://localhost:3000/home/get_photos?tag="+hash_tags[0],
           dataType: 'json',
           success: function(data){
               $('#photos-panel').html("");
                appendPhotos(data);
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
            if ('next_max_id' in pagination){
                if (!$('#loading').length){
                    $('#photos-panel').append($('<div>', {id: 'loading', text: 'Loading...', style: "margin-top: 20px"}));
                }
                $.ajax({
                    url: "http://localhost:3000/home/get_photos?tag="+hash_tags[0]+"&max_id="+pagination['next_max_id'],
                    dataType: 'json',
                    success: function(data)
                    {
                        $('#loading').remove();
                        appendPhotos(data);

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