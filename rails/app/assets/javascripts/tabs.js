$(document).ready(function() {
  $('.tab-index-a').on('click', function(event)  {
    var currentAttrValue = $(this).attr('href');

    // Show/Hide Tabs
    $('.tabs ' + currentAttrValue).show().siblings().hide();
    $('.tabs ' + currentAttrValue).fadeIn(400).siblings().hide();

    // Change/remove current tab to active
    $(this).parent('.tab-index-li').addClass('js-active-tab').siblings().removeClass('js-active-tab');

    event.preventDefault();
  });
});