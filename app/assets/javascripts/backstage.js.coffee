$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $(this).before($(this).data('fields').replace(regexp, time))
  event.preventDefault()

$(document).on 'click', 'form .remove_fields', (event) ->
  $(this).prev('input[type=hidden]').val('1')
  $(this).closest('div').hide()
  event.preventDefault()

# enable chosen js
jQuery ->
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    disable_search_threshold: 10
    width: '200px'

