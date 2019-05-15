Actors: User
Goal: Account search results

Main success scenario

1. System displays search box.
2. User enters property reference number and presses search button.
3. System displays single property matching reference number.

Extensions

2.a. User enters property address string and presses search button
1. displays property list of search query matches

2.b. User enters client reference number and presses search button
1. System displays single client matching reference number

3.a. errors when the property reference is included along with address string
1. The system displays error message of no Matches found.
2. Prompted to search again. The use case continues at step 1.

3.b. errors when the property reference is not included in the system.
1. The system displays error message of no Matches found.
2. Prompted to search again. The use case continues at step 1.

