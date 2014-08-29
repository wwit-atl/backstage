# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery.fn.fadeOutClass = (klass) ->
  if $(this).hasClass(klass)
    $(this).fadeOut().promise().done( -> $(this).removeClass(klass) )
  else
    $(this)

jQuery.fn.fadeInClass = (klass) ->
  if $(this).hasClass(klass)
    $(this).fadeIn()
  else
    $(this).addClass(klass).promise().done( -> $(this).fadeIn() )

jQuery ->
  $('.scroll-to-top').click( (event)->
    event.preventDefault()
    $('html,body').animate({scrollTop:0}, 500, 'swing')
    return false
  )

  $('.scroll-to-link').click( (event)->
    dest = 0
    target = this.hash

    event.preventDefault()

    if( $(target).offset().top > $(document).height()-$(window).height())
      dest = $(document).height()-$(window).height()
    else
      dest=$(target).offset().top

    $('html,body').animate({scrollTop:dest - 60}, 500, 'swing')
  )

window.calendarClick = (eventDate) ->
  changeCounts = (cur, max) ->
    $('span.cur-count').text(curCount)
    $('span.max-count').text(maxCount)

  # Get the event clicked and toggle the selected class
  event = $(document.getElementById(eventDate))
  event.toggleClass('selected')

  # Removed locked class if it has it.
  event.removeClass('locked')

  # This is the div holding the maximimum conflicts message
  noteDiv = $('#max-note')

  # Get how many conflicts are curretly selected
  curCount = $('.selected').not('.notmonth').length

  # What's our max?  (sent via data-max-conflicts)
  maxCount = noteDiv.attr('data-max-conflicts')
  underLimitMessage = noteDiv.attr('data-note-underlimit')
  atLimitMessage =    noteDiv.attr('data-note-atlimit')
  overLimitMessage =  noteDiv.attr('data-note-overlimit')

  # We're using .promise().done(function() {} ) to ensure our animations complete in sequence.
  if ( curCount < maxCount )
    noteDiv.fadeOutClass('at-limit').promise().done( ->
      $('span.note-message').html(underLimitMessage)
      changeCounts(curCount, maxCount)
      $(this).fadeInClass('under-limit')
    )

  else if ( curCount > maxCount )
    # Apply over-limit class if we haven't already done so
    noteDiv.fadeOutClass('at-limit').promise().done( ->
      $('span.note-message').html(overLimitMessage)
      changeCounts(curCount, maxCount)
      $('span.over-limit-note').fadeIn()
      $(this).fadeInClass('over-limit')
    )

  # Must be ==, so remove over-limit class if it's been applied
  else
    noteDiv.fadeOutClass('over-limit').promise().done( ->
      $(this).fadeOutClass('under-limit').promise().done( ->
        $('span.note-message').html(atLimitMessage)
        changeCounts(curCount, maxCount)
        $('.over-limit-note').fadeOut()
        $(this).fadeInClass('at-limit')
      )
    )


