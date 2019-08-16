require 'rails_helper'

RSpec.describe Charge, :ledgers, :range, :cycle, type: :model do
  describe 'validations' do
    it('is valid') { expect(charge_new).to be_valid }
    describe 'presence' do
      it('charge type') { expect(charge_new charge_type: nil).not_to be_valid }
      it('amount') { expect(charge_new amount: nil).not_to be_valid }
      describe 'amount when zero' do
        it 'rejects active' do
          expect(charge_new amount: 0, activity: 'active').not_to be_valid
        end
        it 'allows dormant' do
          expect(charge_new amount: 0, activity: 'dormant').to be_valid
        end
      end

      it('cycle') { expect(charge_new cycle: nil).not_to be_valid }
    end

    describe 'payment type' do
      it 'accepts string' do
        expect(charge_new payment_type: 'manual').to be_valid
      end
      it 'accepts const' do
        expect(charge_new payment_type: 'manual').to be_valid
      end
      it('rejects nil') { expect(charge_new payment_type: nil).not_to be_valid }
    end

    describe 'amount' do
      it('is a number') { expect(charge_new amount: 'nn').not_to be_valid }
      it('has a max') { expect(charge_new amount: 100_000).not_to be_valid }
    end
  end

  describe 'methods' do
    it('responds to monthly') { expect(charge_new).not_to be_monthly }

    describe '#clear_up_form' do
      it 'keeps charges by default' do
        expect(described_class.new).not_to be_marked_for_destruction
      end

      it 'clears new charges if asked' do
        (charge = described_class.new).clear_up_form
        expect(charge).to be_marked_for_destruction
      end

      it 'keeps new charges if edited' do
        (charge = described_class.new).charge_type = 'Rent'
        charge.clear_up_form
        expect(charge).not_to be_marked_for_destruction
      end
    end

    describe '#coming' do
      it 'charges if billing period crosses a due_on' do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])

        expect(ch.coming Date.new(2013, 3, 5)..Date.new(2013, 3, 5))
          .to eq [chargeable_new(charge_id: ch.id,
                                 at_time: Date.new(2013, 3, 5))]
      end

      it 'returns charges in date order - regardless of crossing year'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month:  3, day:  5),
                                                   DueOn.new(month: 12, day: 30)])

        expect(ch.coming Date.new(2010, 9, 5)..Date.new(2011, 9, 4))
          .to eq [chargeable_new(charge_id: ch.id,
                                 at_time: Date.new(2010, 12, 30)),
                  chargeable_new(charge_id: ch.id,
                                 at_time: Date.new(2011, 3, 5))]
      end

      it 'no charge if billing period misses all due_on' do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])

        expect(ch.coming Date.new(2013, 2, 1)..Date.new(2013, 3, 4)).to eq []
      end

      it 'excludes dormant charges from billing'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])
        ch.activity = 'dormant'
        expect(ch.coming Date.new(2013, 3, 5)..Date.new(2013, 3, 5)).to eq []
      end

      it 'anchors charges around billing period'  do
        ch = charge_new cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 5)])

        expect(ch.coming Date.new(2032, 3, 5)..Date.new(2032, 3, 5))
          .to eq [chargeable_new(charge_id: ch.id,
                                 at_time: Date.new(2032, 3, 5))]
      end
    end

    describe '#automatic?' do
      it 'returns automatic payment when standing order' do
        charge = charge_new payment_type: 'automatic'
        expect(charge).to be_automatic
      end

      it 'returns automatic payment when standing order' do
        charge = charge_new payment_type: 'manual'
        expect(charge).not_to be_automatic
      end
    end

    it '#to_s displays' do
      expect(charge_new.to_s)
        .to eq 'charge: Ground Rent, '\
               'cycle: Mar, type: term, charged_in: advance, due_ons: [Mar 25]'
    end
  end
end
