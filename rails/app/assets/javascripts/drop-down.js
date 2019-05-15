
$(document).ready(function() {
  $('.drop-down-menu').bind('mouseover', openSubMenu);
  $('.drop-down-menu').bind('mouseout', closeSubMenu);

  function openSubMenu() {
    $(this).find('ul').css('visibility', 'visible');
  };

  function closeSubMenu() {
    $(this).find('ul').css('visibility', 'hidden');
  };

});
