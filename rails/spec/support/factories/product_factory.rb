# rubocop: disable  Metrics/ParameterLists

def product_new \
  invoice: invoice_new,
  charge_type: 'Rent',
  date_due: '2014-06-07',
  payment_type: 'manual',
  amount: 30.05,
  balance: 30.05,
  period: Date.new(2010, 9, 30)..Date.new(2011, 3, 25)

  product = Product.new charge_type: charge_type,
                        date_due: date_due,
                        payment_type: payment_type,
                        amount: amount,
                        balance: balance,
                        period: period
  product.invoice = invoice if invoice
  product
end
