require 'spec_helper'

describe Charge, type: :model do
  let(:charge) do
    charge = Charge.new charge_attributes id: 1
    charge.due_ons.new due_on_attributes_0 charge_id: 1
    charge
  end

  it('is valid') { expect(charge).to be_valid }

  describe 'validations' do
    describe 'presence' do

      it 'charge type' do
        charge.charge_type = nil
        expect(charge).to_not be_valid
      end

      it 'due in' do
        charge.due_in = nil
        expect(charge).to_not be_valid
      end

      it 'amount' do
        charge.amount = nil
        expect(charge).to_not be_valid
      end

      it 'due_ons' do
        charge.due_ons.destroy_all
        expect(charge).to_not be_valid
      end
    end
    describe 'amount' do
      it 'is a number' do
        charge.amount = 'nnn'
        expect(charge).to_not be_valid
      end
      it 'has a maximum' do
        charge.amount = 100_000
        expect(charge).to_not be_valid
      end
    end
  end

  describe 'methods' do
    describe 'charging' do
      let(:charge) do
        charge = Charge.new charge_attributes id: 1, due_in: 'Advance'
        charge.due_ons.new charge_id: 1, day: 25, month: 3
        charge.due_ons.new charge_id: 1, day: 29, month: 9
        charge
      end

      before(:each) { Timecop.travel(Date.new(2013, 1, 31)) }
      after(:each)  { Timecop.return }

      describe '#next_chargeable' do
        it 'creates chargeables if in range'  do
          expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                        Date.new(2013, 3, 25)))
            .to eq [chargeable(Date.new(2013, 3, 25))]
        end

        it 'multi year range it charges all due_ons within date-range - ONCE' do
          expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                        Date.new(2016, 3, 25)))
            .to eq [chargeable(Date.new(2013, 3, 25)),
                    chargeable(Date.new(2013, 9, 29))]
        end

        it 'dormant charges do not create chargeables'  do
          charge.dormant = true
          expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                        Date.new(2013, 3, 25)))
            .to eq []
        end

        # pending
        it 'if charge between dates Advance Date period 25-3- to 28-9'
        # expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
        #                               Date.new(2016, 3, 25)))
        # .to eq [chargeable(Date.new(2013, 3, 25)),
        #         chargeable(Date.new(2013, 9, 28))]

        it 'if charge only 1 date Advance Date 1-4 to 31-3'  do
          Timecop.travel(Date.new(2013, 3, 10))
        end

        it 'ignores charges which have debits'  do
          charge.debits.build debit_attributes on_date: '2013-3-25'
          expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
                                        Date.new(2016, 3, 25)))
            .to eq [chargeable(Date.new(2013, 9, 29))]
        end

        it 'return empty array if no charge' do
          expect(charge.next_chargeable(dates_not_charged_on)).to eq []
        end

        it 'returns empty array if charge dormant' do

        end
      end

      def chargeable date
        ChargeableInfo.from_charge(chargeable_attributes on_date: date)
      end

      def dates_not_charged_on
        Date.new(2013, 2, 1)..Date.new(2013, 3, 24)
      end
    end

    it '#prepare creates children' do
      charge.prepare
      expect(charge.due_ons.size).to eq(4)
    end

    it '#clear_up_form destroys children' do
      charge.clear_up_form
      expect(charge.due_ons.size).to eq(1)
    end

  end

  describe 'methods' do
    describe 'charging' do
      let(:charge) do
        charge = Charge.new charge_attributes id: 1, due_in: 'Arrears'
        charge.due_ons.new charge_id: 1, day: 25, month: 3
        charge.due_ons.new charge_id: 1, day: 29, month: 9
        charge
      end

      before(:each) { Timecop.travel(Date.new(2013, 1, 31)) }
      after(:each)  { Timecop.return }

      describe '#next_chargeable' do
        # pending
        it 'if charge between dates Arrears Date period 25-3- to 28-9'
        # pending 'spec missing and structure of tests wrong'
        # expect(charge.next_chargeable(Date.new(2013, 3, 25)..\
        #                               Date.new(2016, 3, 25)))
        # .to eq [chargeable(Date.new(2012, 9, 30)),
        #         chargeable(Date.new(2013, 3, 25))]
      end
    end
  end

  describe 'methods' do
    describe 'charging' do
      let(:charge) do
        charge = Charge.new charge_attributes id: 1, due_in: 'Midterm'
        charge.due_ons.new charge_id: 1, day: 25, month: 3
        charge.due_ons.new charge_id: 1, day: 29, month: 9
        charge
      end

      before(:each) { Timecop.travel(Date.new(2013, 1, 31)) }
      after(:each)  { Timecop.return }

      describe '#next_chargeable' do
        it 'if charge between dates Midterm Date period 25-3- to 28-9'
      end
    end
  end
end