// Grid row click simulation
//
// see $module-table-row in app/assets/stylesheets for more information.
//
$(document).ready(function() {
  $("div[data-link]").click(function() {
    window.location = $(this).data("link");
  });
});