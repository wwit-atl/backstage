jQuery ->
  $("input.datepicker").each (i) ->
    $(this).datepicker
      altFormat: "yy-mm-dd"
      dateFormat: "mm/dd/yy"
      altField: $(this).next()

  $("input.timepicker").each (i) ->
    $(this).timepicker
      timeFormat: 'g:ia'
      scrollDefaultTime: '8:00pm'
