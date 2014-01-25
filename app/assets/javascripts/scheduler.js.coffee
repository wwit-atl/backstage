schedulerReady = ->
  # Hide the Scheduler errors div by default (we'll expose it when necessary)
  $("#scheduler.errors").hide();

  # Listen to the close event
  $("#scheduler.errors .close").click ->
    $(this).parent.slideUp();

$(document).ready(schedulerReady)
$(document).on 'page:load', schedulerReady
$(document).on 'ajax:success', schedulerReady
