ready = ->
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    disable_search_threshold: 10
    width: '200px'

  $("input.datepicker").each ->
    $(this).datepicker
      altFormat: "yy-mm-dd"
      dateFormat: "mm/dd/yy"
      altField: $(this).next()

  $("input.timepicker").each ->
    $(this).timepicker
      timeFormat: 'g:ia'
      scrollDefaultTime: '8:00pm'
      step: 15

  $('#calendar').fullCalendar
#    put your options and callbacks here


$(document).ready(ready)
$(document).on 'page:load', ready
$(document).on 'cocoon:after-insert', ready
