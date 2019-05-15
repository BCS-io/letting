Actors: User
Goal: Printing out invoiceable accounts
Precondition: Invoicing has already been created

Main success scenario

1. System displays an invoice and lists those that can be printed out and retained.
2. User Presses the Print option.
3. System Print outs the invoices that can be printed.

Extensions

1.a. Deliver message: informs user, if no invoice delivered and disables printing.
  1. System disables the print button.
  2. System displays informational information - nothing for the user to do.

1.b. Retained Message: Informs user, if no invoice retained.
  1. System displays warning message
  2. System continues at main step 2.

1.c. System print out 'Ignored' section if an account cannot possibly be invoiced.
  1. Accounts that have no charge for the billing period are listed under ignored.
  2. System continues at main step 2.



Definitions

Ignored Account
- An account that can not be invoiced for this billing period - any charges that
  the account has will not be due for the billing period