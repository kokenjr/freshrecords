# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  current_page = location.pathname
  if current_page != "/artists"
    if $('.pagination').length
      $(window).scroll ->
        url = $('.pagination .next_page').attr('href')
        if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
          $('.pagination').text("Pressing more records...")
          $.getScript(url)
      $(window).scroll()

  $(document).on 'click', '.wish-list-button', ->
    $(this).toggleClass "active"
    intRegex = /[0-9 -()+]+$/
    id = $(this).attr('id').match(intRegex)
    current_page = location.pathname
    if current_page == "/wish-list"
      $("#record-" + id).toggle()

  $(document).on 'mouseenter', '.record-each', ->
    $(this).find('.popup').show();
  $(document).on 'mouseleave', '.record-each', ->
      $(this).find('.popup').hide();
