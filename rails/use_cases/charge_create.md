Actors: User
Goal: Create a charge
Success Guarantees: A charge has been created for an account.

Main success scenario - adds a charge
1. System displays an account with empty charge row
2. User adds Charge, Date Due, Payment, Amount and Updates an account.
3. The system validates, returns to accounts index page and displays success.

Extensions

2.a. Create two charges at once
1. User adds two pairs of Charge, Date Due, Payment, Amount and Updates an account.
2. The system validates, returns to accounts index page and displays success.

2.b. Fills in charge but deletes it before updating
1. User adds a Charge, Date Due, Payment, Amount.
2. User deletes the charge.
3. User updates an account.
4. The system validates, returns to accounts index page and displays success.
