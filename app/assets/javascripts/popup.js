$(document).ready(function() {
  $(".record-each").each(function(index) {
    $(this).hover(function() {
      $(this).find('.popup').show();
    }, function() {
      $('.popup').hide();
    });
  });
});
