$( document ).ready(function() {
  // js print window
  $('.js-print').click(function() {
    window.print();
    return false;
  });
});

function print_n_ret() {
  var is_chrome = Boolean(window.chrome);
  if(is_chrome) 
  {
    window.print();
    setTimeout(function(){window.close(); history.go(-1); }, 200); 
  }
  else
  {
    window.print();
    history.go(-1);
  }
  return false;
}
