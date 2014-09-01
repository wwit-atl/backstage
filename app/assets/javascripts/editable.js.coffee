$.fn.editable.defaults.mode = 'inline';
$.fn.editable.defaults.toggle = 'dblclick';

jQuery ->
#  $('.editable').editable();
  $('.editable-toggle').click( (e)->
    e.stopPropagation();
    e.preventDefault();
    $('.editable[data-pk=' + $(this).attr('data-pk') + ']').editable('toggle');
  );

