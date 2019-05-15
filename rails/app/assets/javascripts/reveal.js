
$( document ).ready(function() {


  // Revealing a link
  //
  // uncover an hidden element and disable the add button if there are
  // no more elements to reveal.
  //
  $('.js-reveal-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-group-toggle')
           .children('.js-revealable:hidden:first')
           .slideToggle('fast');

    // Disable an Add link if we have run out of revealable elements
    // and make visual change
    if ($(this).closest('.js-group-toggle')
           .children('.js-revealable:hidden')
           .length < 1) {
      $(this).addClass('js-color-disabled');
      $(this).prop('Enabled', 'False');
    }
  });

  // Hiding a link
  //
  // Hide a record row and enable the 'Add' link
  //
  // - For a new record - we transition to hiding the record
  //   clear the record of content, and
  //
  // We apply a visual effect and clear the fields for reuse.
  //
  $('.js-hide-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-enclosed-toggle').slideToggle('fast');
    $(this).closest('.js-enclosed-toggle').find('.js-clear').val('');

    // Enable an Add link and make visual change
    $(this).closest('.js-group-toggle')
           .find('.js-reveal-link')
           .prop('Enabled', 'True');
    $(this).closest('.js-group-toggle')
           .find('.js-reveal-link')
           .removeClass('js-color-disabled');
  });

  // Destroying a link
  //  - For a persisted record we need to flag record for delete, disable, and hide
  //    and not reuse the record until we have committed delete to the server.
  //  - _destroy field to '1' or true
  //
  $('.js-destroy-link').click(function(event) {
    event.preventDefault();
    // previous hidden should be a _destroy field
    $(this).prev('input[type=hidden]').val('1')
    // visual effects
    $(this).closest('.js-enclosed-toggle').slideToggle('fast');
    $(this).closest('.js-enclosed-toggle').find('.js-clear').prop('disabled', true)
  });
});
