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

  // Scrolls to the selected menu item on the page
  $('a[href*=#]:not([href=#])').click(function() {
      if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') || location.hostname == this.hostname) {

          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
          if (target.length) {
              $('html,body').animate({
                  scrollTop: target.offset().top
              }, 500);
              return false;
          }
      }
  });
});