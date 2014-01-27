schedulerReady = ->
  # Hide the Scheduler errors div by default (we'll expose it when necessary)
  $("#scheduler.errors").hide();

schedulerAjaxReady = ->
  # Listen to the close event
  $("#scheduler.errors button.close").click ->
    $('#scheduler.errors').slideUp();

$(document).ready(schedulerReady)
$(document).on 'page:load', schedulerReady
$(document).on 'ajax:success', schedulerAjaxReady
