require 'rails_helper'
require_relative '../../../lib/modules/charge_types'
include ChargeTypes

RSpec.describe AccountsDebits, type: :model do
  # order by charge, property_ref
  # display contiguous numbers with '-'

  describe '#list' do
    it 'produces debits for due charges' do
      chg = charge_create amount: 80.08,
                          cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
      account_create property: property_new(human_ref: 2), charges: [chg]

      debits = AccountsDebits.new(property_range: '2',
                                  debit_period: '2013-3-5'..'2013-3-5')
      expect(debits.list).to eq [Date.new(2013, 3, 5), 'Ground Rent'] =>
                                  AccountDebit.new(date_due: Date.new(2013, 3, 5),
                                                   charge_type: 'Ground Rent',
                                                   property_ref: 2,
                                                   amount: nil)
    end

    it 'produces ordered account debits' do
      chg1 = charge_create(charge_type: GROUND_RENT,
                           cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)]))
      chg2 = charge_create(charge_type: SERVICE_CHARGE,
                           cycle: cycle_new(due_ons: [DueOn.new(month: 2, day: 5)]))
      chg3 = charge_create(charge_type: INSURANCE,
                           cycle: cycle_new(due_ons: [DueOn.new(month: 8, day: 5)]))
      account_create property: property_new(human_ref: 2), charges: [chg1, chg2, chg3]

      debits = AccountsDebits.new(property_range: '2',
                                  debit_period: '2013-1-1'..'2014-1-1')

      expect(debits.list).to eq [Date.new(2013, 2, 5), 'Service Charge'] =>
                                  AccountDebit.new(date_due: Date.new(2013, 2, 5),
                                                   charge_type: 'Service Charge',
                                                   property_ref: 2,
                                                   amount: nil),
                                [Date.new(2013, 3, 5), 'Ground Rent'] =>
                                  AccountDebit.new(date_due: Date.new(2013, 3, 5),
                                                   charge_type: 'Ground Rent',
                                                   property_ref: 2,
                                                   amount: nil),
                                [Date.new(2013, 8, 5), 'Insurance'] =>
                                  AccountDebit.new(date_due: Date.new(2013, 8, 5),
                                                   charge_type: 'Insurance',
                                                   property_ref: 2,
                                                   amount: nil)
    end
  end
end
