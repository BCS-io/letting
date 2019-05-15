$( document ).ready(function() {

  $('.js-close-click').click(function(event) {
    $(this).slideToggle('fast');
  });
});

function readyFn( jQuery ) {
  setTimeout(function () { $('.js-close-time').slideToggle('fast'); }, 2000);
}

function slowFn( jQuery ) {
  setTimeout(function () { $('.js-slow-time').slideToggle('slow'); }, 7000);
}

$( document ).ready( readyFn );
$( document ).ready( slowFn );

