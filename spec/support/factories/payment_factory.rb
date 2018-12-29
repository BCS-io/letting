# rubocop: disable Metrics/ParameterLists

def payment_new id: nil,
                account_id: nil,
                account: nil,
                booked_at: Time.zone.local(2013, 4, 30, 1, 0, 0),
                amount: 88.08,
                credit: nil
  payment = Payment.new id: id,
                        account_id: account_id,
                        booked_at: booked_at
  payment.amount = amount if amount
  payment.credits << credit if credit
  payment.account_id = account_id if account_id
  payment.account = account if account
  payment
end

def payment_create id: nil,
                   account_id: nil,
                   account: nil,
                   booked_at: Time.zone.local(2013, 4, 30, 1, 0, 0),
                   amount: 88.08,
                   credit: nil
  payment = payment_new id: id,
                        account_id: account_id,
                        account: account,
                        booked_at: booked_at,
                        amount: amount,
                        credit: credit
  payment.save!
  payment
end
