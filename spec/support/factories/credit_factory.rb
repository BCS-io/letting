# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

#
# Most credit amounts will be negative
# Negative amount results in a negative in the database
#

def credit_new payment_id: 1,
               account_id: 1,
               charge_id: nil,
               charge: nil,
               on_date: '30/4/2013 00:00:00',
               amount: 88.08

  credit = Credit.new payment_id: payment_id,
                      account_id: account_id,
                      charge_id: charge_id,
                      amount: amount
  credit.on_date = on_date if on_date
  credit.charge_id = charge_id if charge_id
  credit.charge = charge if charge
  allow(credit).to receive(:debit_outstanding).and_return(-88.08)
  credit
end

def credit_create payment_id: 1,
                  account_id: 1,
                  charge_id: nil,
                  charge: nil,
                  on_date: '30/4/2013 00:00:00',
                  amount: 88.08
  credit = credit_new payment_id: payment_id,
                      account_id: account_id,
                      charge_id: charge_id,
                      charge: charge,
                      on_date: on_date,
                      amount: amount
  credit.save!
  credit
end
