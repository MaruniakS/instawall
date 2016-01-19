$(document).ready(function(){
    var hash_tags = [];
    var pagination = "";
    var photos_id_array = [];
    function appendPhotos(data){
        if ('hash_tags' in data){
            hash_tags = data['hash_tags'];
        }
        pagination = data['pagination'];
        data = data['photos'];
        for (var i = 0; i < data.length; i++){
            if ($.inArray(data[i]['caption']['id'], photos_id_array) === -1) {
                photos_id_array.push(data[i]['caption']['id']);
                $('#photos-panel').append(
                    $('<img>', {class: "img-thumbnail photos", src: data[i]['images']['standard_resolution']['url']})
                );
            }
        }
    }

    function doAjax(type){
        var ajax_url = "";
        if (type === "get"){
            ajax_url = "http://localhost:3000/home/get_photos?tag="+hash_tags[0];
        }
        else
        {
            ajax_url = "http://localhost:3000/home/get_photos?tag="+hash_tags[0]+"&max_id="+pagination['next_max_id'];
        }
        if (!$('#loading').length){
            $('#photos-panel').append($('<div>', {id: 'loading', text: 'Loading...', style: "margin-top: 20px"}));
        }
        $.ajax({
            url: ajax_url,
            dataType: 'json',
            success: function(data){
                $('#loading').remove();
                if (type === "get") {$('#photos-panel').append($('<h3>', {text: '#'+hash_tags[0], class: 'text-info', style: 'margin-top:20px'}));}
                appendPhotos(data);
            },
            error: function(err){
                $('#photos-panel').html("Something went wrong: " + err);
            }

        });
    }

   $('#srch-btn').click(function(){
       $('#photos-panel').html("");
       photos_id_array = [];
       var tags_string = $('#hash-input').val();
       hash_tags = tags_string.split(/[# ]/).filter(Boolean);
       //$('#photos-panel').append($('<img>', {src: "../../../public/loading.gif"}));
       doAjax("get");
   });

    $(window).scroll(function()
    {
        if($(window).scrollTop() == $(document).height() - $(window).height())
        {
            if ('next_max_id' in pagination){
                doAjax("load");
            }
            else if (hash_tags.length > 1){
                hash_tags.shift();
                doAjax("get");
            }
            else {

            }

        }
    });
});