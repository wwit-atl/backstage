ready = ->
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    disable_search_threshold: 10
    width: '200px'

  $("input.datepicker").each ->
    $(this).datepicker
      dateFormat: "yy-mm-dd"
      altField: $(this).next()

  $("input.timepicker").each ->
    $(this).timepicker
      timeFormat: 'g:ia'
      scrollDefaultTime: '8:00pm'
      step: 15

  $("#scheduler.errors").hide();

  $('tbody.reposition').sortable(
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
  );

$(document).ready(ready)
$(document).on 'page:load', ready
$(document).on 'cocoon:after-insert', ready
