require 'rails_helper'

RSpec.describe 'ChargeFactory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(charge_new).to be_valid }
      it('has account_id') { expect(charge_new.account_id).to eq 2 }
      it('has cycle_id') { expect(charge_new.cycle_id).to be_nil }
      it('has type') { expect(charge_new.charge_type).to eq 'Ground Rent' }
      it('has cycle') { expect(charge_new.cycle.name).to eq 'Mar' }
      it 'has due_ons' do
        expect(charge_new.cycle.due_ons.size).to eq 1
      end
      it 'has due ons' do
        expect(charge_new.cycle.due_ons[0])
          .to eq DueOn.new(month: 3, day: 25)
      end
      describe 'makes' do
        it 'creates cycle' do
          expect(charge_new.cycle.name).to eq 'Mar'
        end
      end

      describe 'adds' do
        it 'can add cycle' do
          cycle = cycle_new name: 'Mar'
          expect(charge_new(cycle: cycle).cycle.name).to eq 'Mar'
        end

        it 'shovels debit' do
          expect(charge_new(debits: [debit_new]).debits.first.amount)
            .to eq 88.08
        end

        it 'displays charge type through debit' do
          debit = charge_new(charge_type: 'Rent', debits: [debit_new])
                  .debits.first
          expect(debit.charge_type).to eq 'Rent'
        end
      end
    end
  end

  describe 'charge_find_or_new' do
    it 'instantiates object if missing' do
      expect(charge_find_or_create(id: 1).amount).to eq 88.08
    end
    it 'can be called many times' do
      charge_find_or_create id: 1
      expect { charge_find_or_create id: 1 }.not_to raise_error
    end
  end

  describe 'create' do
    context 'default' do
      it 'is created' do
        expect { charge_create }.to change(Charge, :count).by(1)
      end

      it 'has charge type' do
        charge_create
        expect(Charge.first.charge_type).to eq 'Ground Rent'
      end

      it 'is an active charge' do
        charge_create
        expect(Charge.first).not_to be_dormant
      end

      describe 'makes' do
        it 'creates cycle' do
          expect { charge_create }.to change(Cycle, :count).by(1)
        end
      end
    end

    describe 'override' do
      it 'alters charge type' do
        charge_create charge_type: 'Garage'
        expect(Charge.first.charge_type).to eq 'Garage'
      end

      it 'flips activity dormant' do
        expect(charge_create activity: 'dormant').to be_dormant
      end
    end

    describe 'adds' do
      it 'can add cycle' do
        expect do
          charge_create cycle: cycle_create(id: 5)
        end.to change(Cycle, :count).by(1)
        expect(Cycle.first.id).to eq(5)
      end
    end
  end
end
