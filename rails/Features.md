Charge

Charges have a start date and end date
* initialized to max date and min date.
* Outside the date range we do not debit the charge
* deactivate a charge - inactive charges can no longer create a debit.
  * deleting a charge is only possible if all debits and credits associated with the charge are also deleted - this might not be what they wanted!


Debit

For each charge it creates a debit for 'due ons' within the data range
  * if the date range covers multiple years on the first year is charged (!)

