// Toggle Event
// 1) User clicks on js-toggle or js-checkbox-toggle
// 2) doToggle called
// 3) Up the DOM till we find js-toggle-selection and then
//    slide it's js-togglable chidren
// 4) Trigger toggleEventHandler - which moves up the DOM until it is handled
// 5) Hits the js-clear handler (or not) which clears the html component
//
// Toggle used in Address.html and the address_decorator -
// see address_decorator for further information.

$( document ).ready(function() {
  // Initialization of check box state
  // checkbox state affects visibility of selected
  // js classes (js-check-hidden, js-check-visible)
  // event run on page creation and if checkbox toggled.
  //
  if ($('.js-checkbox-toggle').is(':checked')) {
    $('.js-check-hidden').css('display', 'none');
    $('.js-check-visible').css('display', 'block');
  }

  $('.js-toggle').click(function(event) {
    event.preventDefault();
    doToggle($(this));
  });

  $('.js-checkbox-toggle').click(function(event) {
    doToggle($(this));
  });

  function doToggle(toggle) {
    toggle.closest('.js-toggle-selection')
          .children('.js-togglable')
          .slideToggle('fast');
    // bubbles up the DOM until it finds a toggleEventHandler
    toggle.trigger('toggleEventHandler');
  }

  // When toggle event fired it clears field
  // Works on the address district and Nation
  // delete and add cycling.
  //
  $('.js-clear').on('toggleEventHandler', function() {
    $(this).find(':input').val('');
  });
});
