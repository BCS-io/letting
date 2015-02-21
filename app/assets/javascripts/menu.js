/*jQuery time*/
$(document).ready(function(){
  $(".accord h3").click(function(){
    //slide up all the link lists
    $(".accord ul ul").slideUp();
    //slide down the link list below the h3 clicked - only if its closed
    if(!$(this).next().is(":visible"))
    {
      $(this).next().slideDown('fast');
    }
  })
})