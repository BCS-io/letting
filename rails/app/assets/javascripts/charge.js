//
// Dynamic Select Box
//
// http://railscasts.com/episodes/88-dynamic-select-menus-revised?view=asciicast
//
// Select boxes using class identifier instead of id (as we need) more than one
// selected box on the same form.
// js-dynamic-group - outer box containing the related select boxes.
// js-dynamic-filter - selecting drop-down filters the results
// js-dynamic-result - the drop-down whose results are reduced by the filtering.
//
// How the select appears in html.
//
// js-dynamic-filter
//
// <select class="js-dynamic-filter" name="property[account_attributes][charges_attributes][0][cycle_id]">
// <option value="1">Mar 25th / Sep 29th</option>
// <option selected="selected" value="4">Jun 24th / Dec 25th</option>
// <option value="4">Jun 25th / Dec 25th</option>
// </select>
//
// js-dynamic-result
//
// <select class="js-dynamic-result" name="property[account_attributes][charges_attributes][0][charged_in]">
//   <option value=""></option>
//   <optgroup label="Mar 25th / Sep 29th">
//     <option selected="selected" value="1">Arrears</option>
//     <option value="2">Advance</option>
//     <option value="3">Mid-Term</option>
//   </optgroup>
//   <optgroup label="Jun 24th / Dec 25th">
//     <option selected="selected" value="1">Arrears</option>
//     <option value="2">Advance</option>
//   </optgroup>
//   <optgroup label="Jun 25th / Dec 25th">
//     <option value="2">Advance</option>
//   </optgroup>
// </select>
//
// updatepayment options is updated each time js-dynamic filter is changed
// in this case when Mar 25th / Sep 29th is selected the js-dynamic-result becomes:
//
// <option selected="selected" value="1">Arrears</option>
// <option value="2">Advance</option>
// <option value="3">Mid-Term</option>

// ready - executes when HTML-Document is loaded and DOM is ready
$( document ).ready(function() {
  var results;
  results = $('.js-dynamic-result').html();
  console.log(results);

  // trigger fires the event handler bound element without a user interaction
  // $('.js-dynamic-filter').trigger('change');
  $('.js-dynamic-filter').change(function(event) {
    event.preventDefault();
    updatePayment($(this));
  }).trigger('change');

  function updatePayment(toggle) {
    filter = $("option:selected", toggle).html();
    escaped_filter = filter.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
    options = $(results).filter("optgroup[label=" + escaped_filter + "]").html();
    console.log(options);
    if (options) {
      return $(toggle).closest('.js-dynamic-group').find('.js-dynamic-result').html(options);
    } else {
      return $(toggle).closest('.js-dynamic-group').find('.js-dynamic-result').empty();
    }
  }
});
