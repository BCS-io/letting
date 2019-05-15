Almost certainly a wrong way of using use_cases but it might be helpful for me:

Actors: User
Goal: Generate a period over which the invoicing occurs

Main success scenario

1 New Invoicing
2 Displays search dates 'within 7 weeks or choose dates'
3 Create Invoicing - uses default date range.

2a The user switches to set dates but switches back to the default search dates.
3 Create Invoicing - uses default date range.


Secondary success scenario

1 New Invoicing
2 Displays search dates 'within 7 weeks or choose dates'
3 Click 'or choose dates' and Enter a start date and end date
4 Create invoicing - start and end being the dates set in 3