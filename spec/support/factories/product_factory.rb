# rubocop: disable  Metrics/MethodLength, Metrics/ParameterLists

def product_new \
  charge_type: 'Rent',
  date_due: '2014-06-07',
  automatic_payment: false,
  amount: 30.05,
  balance: 30.05,
  period: Date.new(2010, 9, 30)..Date.new(2011, 3, 25)

  Product.new charge_type: charge_type,
              date_due: date_due,
              automatic_payment: automatic_payment,
              amount: amount,
              balance: balance,
              period: period
end
