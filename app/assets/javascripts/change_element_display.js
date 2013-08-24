
function setBlockDisplay(elId,fieldset)
{
  if (document.getElementById(elId).value.length > 0)
  {
    document.getElementById(fieldset).style.display="block";
  }
  else
  {
    document.getElementById(fieldset).style.display="none";
  }
}

function setFieldDisplay(elId)
{
  if (document.getElementById(elId).value.length > 0)
  {
    document.getElementById(elId).style.visibility="visible";
  }
  else
  {
    document.getElementById(elId).style.visibility="hidden";
  }
}

function changeFieldDisplay(elId)
{
  document.getElementById(elId).style.visibility="visible";
}


function addFieldDisplay(fieldset0,fieldset1,fieldset2,buttonId)
{
  var chargefields = new Array(fieldset0,fieldset1,fieldset2);
  var foundblockspace = false;
  var count = -1;

  while (foundblockspace === false)
  {
    count = count+1;
    if (document.getElementById(chargefields[count]).style.display == 'none')
    {
     document.getElementById(chargefields[count]).style.display="block";
    foundblockspace = true;
    }
    if (count == 2)
    {
      foundblockspace = true;
      document.getElementById(buttonId).style.visibility="hidden";
    }
   }
 }

function toggleFieldDisplay(fieldset,buttonId,addText,removeText)
{
  if (document.getElementById(fieldset).style.display == 'none')
  {
    document.getElementById(fieldset).style.display="block";
    document.getElementById(buttonId).innerHTML = removeText;
   }
   else
   {
   document.getElementById(fieldset).style.display="none";
   document.getElementById(buttonId).innerHTML = addText;
  }
}

$(function () {
  $("#property_charge_1").css("display", "none");
  $("#property_charge_2").css("display", "none");
  $("#property_charge_3").css("display", "none");
  $('#property_billing_profile_attributes_use_profile').change(function () {
    $('#blank_slate').toggle(!this.checked);
  }).change(); //ensure visible state matches initially
  $("#removeBut").click(function(event){
  $("#property_charge_1").css("display", "none");
  event.preventDefault();
 });
});

