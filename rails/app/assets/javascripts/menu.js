// Works with module.menu.css
// Hiding and unhiding menus
//
$(document).ready(function(){
  $(".menu-header").click(function(){
    // slide up inactive-menus
    if($(this).parent().is(".inactive-menu")) {
      $(this).parent().find(".menu").slideUp();
    }
    // slide down invisible menus - only
    if(!$(this).next().is(":visible"))
    {
      $(this).next().slideDown('fast');
    }
  })
})