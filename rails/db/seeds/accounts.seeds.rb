

after 'charges', 'properties' do
  class << self
    def create_date months_ago
      Time.zone.today - months_ago.months
    end

    def create_payment
      payment = Payment.new id: 1,
                            account_id: 1,
                            booked_at: create_date(15)
      payment.amount = 88.08
      payment.save!
    end
  end

  Account.create! [
    { id: 1, property_id: 1 },
    { id: 2, property_id: 2 },
    { id: 3, property_id: 3 },
    { id: 4, property_id: 4 },
  ]

  Credit.create! [
    { id: 1,
      payment_id: 1,
      charge_id: 1,
      account_id: 1,
      at_time: create_date(15),
      amount: 88.08,
    },
  ]

  create_payment
end
