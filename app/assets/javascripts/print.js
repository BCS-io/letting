$( document ).ready(function() {
  // js print window
  $('.js-printoff').click(function() {
    window.print();
    return false;
  });
});

function print_n_ret() {
  window.print();
  history.go(-1);
  return false;
}
