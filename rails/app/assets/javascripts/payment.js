// New Payment Page
// JS totals payments and updates the total if user edits payment.
//

$(document).ready(function() {
  calculateTotal($(this).find('.js-credit-payment'));

  // Clicking the X on credit number
  // fires this function that clears the value.
  //
  $('.js-number-clear').click(function(event) {
    event.preventDefault();

    $(this).prev('input').val('0.00')
    calculateTotal(this);
  });

});


// updates the total when amount edited.
$(function () {
  $('.js-credit-payment').keyup(function(){
    calculateTotal(this);
  });
});

// Adds total to credits column
function calculateTotal( src ) {
  var sum = 0,
  tbl = $(src).closest('.js-totalizer');
  tbl.find('.js-credit-payment').each(function( index, elem ) {
    var val = parseFloat($(elem).val());
    if( !isNaN( val ) ) {
      sum += val;
    }
  });
  tbl.find('.js-total-payment').val(sum.toFixed(2));
}
