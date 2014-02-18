delay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()

ready = ->
  $('.bs-popover').popover(
    html: true
  )

  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    disable_search_threshold: 10
    width: '100%'

  $('.chosen-reset').click (event)->
    event.preventDefault()
    $('.chosen-select').val('').trigger('chosen:updated').preventDefault

  $("input.datepicker").each ->
    $(this).datepicker
      dateFormat: "yy-mm-dd"
      altField: $(this).next()

  $("input.timepicker").each ->
    $(this).timepicker
      timeFormat: 'g:ia'
      scrollDefaultTime: '8:00pm'
      step: 15

  $('tbody.reposition').sortable(
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
  );

  # Ajax search on keyup
  $('#member_search input').keyup( ->
    delay (->
      $.get($("#member_search").attr("action"), $("#member_search").serialize(), null, 'script')
      false
    ), 250
  )

$(document).ready(ready)
$(document).on 'page:load', ready
$(document).on 'cocoon:after-insert', ready
