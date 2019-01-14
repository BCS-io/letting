#
# Most credit amounts will be negative
# Negative amount results in a negative in the database
#

def credit_new payment_id: 1,
               account_id: 1,
               charge: charge_new,
               at_time: '30/4/2013 00:00:00',
               amount: 88.08

  credit = Credit.new payment_id: payment_id,
                      account_id: account_id,
                      amount: amount
  credit.at_time = at_time if at_time
  credit.charge = charge if charge
  credit
end

def credit_create payment_id: 1,
                  account_id: 1,
                  charge: charge_new,
                  at_time: '30/4/2013 00:00:00',
                  amount: 88.08
  credit = credit_new payment_id: payment_id,
                      account_id: account_id,
                      charge: charge,
                      at_time: at_time,
                      amount: amount
  credit.save!
  credit
end
