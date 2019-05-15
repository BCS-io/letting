# rubocop: disable Metrics/ParameterLists

def debit_new account_id: 1,
              charge_id: nil,
              charge: nil,
              at_time: '25/3/2013 10:00:00',
              period: Date.new(2013, 3, 25)..Date.new(2013, 6, 30),
              amount: 88.08
  debit = Debit.new account_id: account_id,
                    at_time: at_time,
                    period: period,
                    amount: amount
  debit.charge_id = charge_id if charge_id
  debit.charge = charge if charge
  debit
end

def debit_create account_id: 1,
                 charge_id: nil,
                 charge: nil,
                 at_time: '25/3/2013 10:00:00',
                 period: Date.new(2013, 3, 25)..Date.new(2013, 6, 30),
                 amount: 88.08
  debit = debit_new account_id: account_id,
                    at_time: at_time,
                    period: period,
                    charge_id: charge_id,
                    charge: charge,
                    amount: amount
  debit.save!
  debit
end
