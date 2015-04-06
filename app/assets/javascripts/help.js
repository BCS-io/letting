// note summit is top value because top is not a suitable js name

$( document ).ready(function() {

  $('.js-start-help').click(function() {
    boxReveal = 0;
    summit =  parseInt($("#help-me").attr('data-summit'));
    setLow =  parseInt($("#help-me").attr('data-setLow'));
    // alert('boxReveal is '+boxReveal+' summit is '+summit);
    cover(summit);
    $('#help_0')[0].style.display = 'block';
    return false;
  });

  //Summit values are normally set to 4 or 6
  //setLow: 0 does not show print or logout, -2 does

  $('.js-help').click(function() {

    boxReveal++;

    // alert('boxReveal is '+boxReveal+' summit is '+summit);

    if (boxReveal >= summit )
    {
      cover(summit);
      $('#help_' + (setLow ))[0].style.display = 'block';
      boxReveal = setLow;
    }

    if(boxReveal >= -1)
    {
      $('#help_' + (boxReveal - 1) )[0].style.display = 'none';
      $('#help_' + boxReveal)[0].style.display = 'block';
    }
    return false;

  });

  $('.js-cancel-help').click(function() {
    cover(summit);
    return false;
  });
 });

// If an id which does not exist is set to none the js blows.
// Note js does not accept help-box
function cover(lastBox) {

  for (helpBox = -2;  helpBox < lastBox;  helpBox++)
  {
    $('#help_' + helpBox)[0].style.display = 'none';
  }
  return false;
}
