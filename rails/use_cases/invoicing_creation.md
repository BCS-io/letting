Actors: User
Goal: Create a list of invoices to print
Success Guarantees: Any manual payment account has been invoiced.

Main success scenario

1. System prompts to invoice properties by entering a property range.
2. User enters range to invoice and presses search button.
3. System lists the properties which will be invoiced and those that will be
   retained (billed but not invoiced) and those that will be ignored (no
   charges).
4. The user can optionally fill in invoice date and comments before creating the
   invoice.
5. The system validates, creates the invoices, and messages success, and continues to invoicing_view.

Extensions

3.a. errors when the property range excludes all existing properties.
1. The system displays error message
2. The use case continues at step 1.

3.b. errors when the property range does not include a chargeable property for the billing-period.
1. The system displays error message detailing property's charges.
2. The use case continues at step 1.

3.c. does not invoice properties that remain in credit after billing.
1. The system lists these properties under retained.
2. The system continues to 4.

3.d. warns on retaining mail to properties that only have automatic charges.
1. The system lists these properties under retained.
2. The system continues to 4.

3.e. warns on ignoring mail to properties that have no charges in billing-period.
1. The system lists these properties under forgotten.
2. The system continues to 4.


Definition
Manual payment - any none automatic payment, standing order say, mechanism.
