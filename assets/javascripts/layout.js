$(document).ready(function() {
  // autocomplete
  $('#search_city').autocomplete({
    select: function( event, ui ) {
      $("#station_code").val(ui.item.key);
    },
    source: function(request, response) {
      $.ajax({
          dataType: 'json',
          data: {
            term: request.term
          },
          url: '/autocomplete'
        })
        .done(function(data) {
          response(data);
        })
        .fail(function() {
        });
    },
    minLength: 2
  });
});