def chargeable_new \
  account_id: 2,
  charge_id: 1,
  at_time: Date.new(2013, 3, 25),
  period:  Date.new(2013, 3, 25)..Date.new(2013, 6, 30),
  amount: 88.08

  Chargeable.new account_id: account_id,
                 charge_id: charge_id,
                 at_time: at_time,
                 period: period,
                 amount: amount
end
