require 'rails_helper'

RSpec.describe ClientPayment, :ledgers do
  it 'creates years' do
    Timecop.travel('2014-6-1') do
      payment = ClientPayment.query
      expect(payment.years).to eq %w[2014 2013 2012 2011 2010]
    end
  end

  describe '#accounts_with_period' do
    it 'selects account that have charges within a quarter month' do
      client = client_create(
        properties: [property_new(
          account: account_create(
            charges: [charge_new(
              cycle: cycle_new(name: 'Mar-due-on',
                               due_ons: [DueOn.new(month: 3, day: 4),
                                         DueOn.new(month: 9, day: 4)])
            )]
          )
        )]
      )
      batch_month = BatchMonths.make month: BatchMonths::MAR

      expect(ClientPayment.query(client_id: client.id)
        .accounts_with_period(batch_months: batch_month))
        .to match_array [client.properties.first.account]
    end

    it 'rejects account that belong to another client' do
      client_create(human_ref: 1,
                    properties: [property_new(
                      account: account_create(
                        charges: [charge_new(
                          cycle: cycle_new(name: 'Mar-due-on',
                                           due_ons: [DueOn.new(month: 3, day: 4),
                                                     DueOn.new(month: 9, day: 4)])
                        )]
                      )
                    )])
      batch_month = BatchMonths.make month: BatchMonths::MAR

      other_client = client_create(human_ref: 2)

      expect(ClientPayment.query(client_id: other_client.id)
        .accounts_with_period(batch_months: batch_month))
        .to match_array []
    end

    it 'rejects account that only have charges outside a quarter month' do
      client = client_create(
        properties: [property_new(
          account: account_create(
            charges: [charge_new(
              cycle: cycle_new(name: 'Feb-due-on',
                               due_ons: [DueOn.new(month: 2, day: 4),
                                         DueOn.new(month: 9, day: 4)])
            )]
          )
        )]
      )
      batch_month = BatchMonths.make month: BatchMonths::MAR

      expect(ClientPayment.query(client_id: client.id)
        .accounts_with_period(batch_months: batch_month))
        .to match_array []
    end

    it 'rejects account that are flats' do
      client = client_create(
        properties: [property_new(human_ref: Property::MAX_HOUSE_HUMAN_REF + 1,
                                  account: account_create(
                                    charges: [charge_new(
                                      cycle: cycle_new(name: 'Feb-due-on',
                                                       due_ons: [DueOn.new(month: 3, day: 4),
                                                                 DueOn.new(month: 9, day: 4)])
                                    )]
                                  ))]
      )
      batch_month = BatchMonths.make month: BatchMonths::MAR

      expect(ClientPayment.query(client_id: client.id)
        .accounts_with_period(batch_months: batch_month))
        .to match_array []
    end
  end
end
