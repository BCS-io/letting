require 'rails_helper'

RSpec.describe Credit, :ledgers, type: :model do
  let(:credit) { credit_new amount: 88.08 }

  describe 'validates' do
    describe 'presence' do
      it('is valid') { expect(credit_new).to be_valid }

      it 'at_time' do
        (credit = credit_new).at_time = nil
        expect(credit).not_to be_valid
      end
    end

    describe 'amount' do
      it('is a number') { expect(credit_new amount: 'nan').not_to be_valid }

      it 'has a max' do
        expect(credit_new charge: charge_new, amount: 100_000).not_to be_valid
      end

      it('is valid under max') do
        expect(credit_new charge: charge_new, amount: 99_999.99).to be_valid
      end

      it('has a min') { expect(credit_new amount: -100_000).not_to be_valid }

      it('is valid under min') do
        expect(credit_new charge: charge_new, amount: -99_999.99).to be_valid
      end

      it 'fails zero amount' do
        expect(credit_new charge: charge_new, amount: 0).not_to be_valid
      end
    end
  end

  describe '.total' do
    it 'finds total amount' do
      credit_create charge: charge_create, amount: 30
      expect(described_class.total).to eq(30.0)
    end

    it 'sums multiple amounts' do
      charge = charge_create
      credit_create charge: charge, amount: 20
      credit_create charge: charge, amount: 10
      expect(described_class.total).to eq(30.00)
    end
  end

  describe '.before' do
    it 'finds charges earlier than a date' do
      credit_create charge: charge_create,
                    amount: 30,
                    at_time: Time.zone.local(2008, 3, 2, 0, 0, 0)

      expect(described_class.until(Time.zone.local(2008, 3, 2, 12, 0, 0)).size).to eq 1
    end

    it 'ignores charges later than a date' do
      credit_create charge: charge_create,
                    amount: 30,
                    at_time: Time.zone.local(2008, 3, 2, 12, 0, 0)

      expect(described_class.until(Time.zone.local(2008, 3, 2, 0, 0, 0)).size).to eq 0
    end

    it 'finds income with multiple numbers' do
      charge = charge_create
      credit_create charge: charge, amount: 20
      credit_create charge: charge, amount: 10
      expect(described_class.total).to eq(30.00)
    end
  end

  context 'with default initialize' do
    it 'has at_time' do
      travel_to Date.new(2013, 9, 30) do
        expect(credit_new(at_time: nil).at_time.to_s)
          .to eq Time.zone.local(2013, 9, 30, 0, 0, 0, '+1').to_s
      end
    end
  end

  describe 'class method' do
    describe '.available' do
      it 'a created debit is available' do
        charge = charge_create
        credit1 = credit_create charge: charge, at_time: '2012-4-1', amount: 15

        expect(described_class.available charge.id).to eq [credit1]
      end

      it 'a debit settled by a credit is not available' do
        charge = charge_create
        credit = credit_create charge: charge, at_time: '2012-5-1', amount: -15
        debit_create charge: charge, at_time: '2012-4-1', amount: 15
        expect(credit).to be_spent

        expect(described_class.available charge.id).to eq []
      end

      it 'orders credits by date' do
        last  = credit_new at_time: '2013-4-1'
        first = credit_new at_time: '2012-4-1'
        charge = charge_create credits: [last, first]

        expect(described_class.available charge.id).to eq [first, last]
      end
    end
  end

  describe 'methods' do
    describe '#charge_type' do
      it 'returned when charge present' do
        (credit = credit_new).charge = charge_new charge_type: 'Rent'
        expect(credit.charge_type).to eq 'Rent'
      end

      it 'errors when charge missing' do
        expect { credit_new(charge: nil).charge_type }.to raise_error(NoMethodError)
      end
    end

    describe '#outstanding' do
      it 'returns amount if nothing paid' do
        credit = credit_create amount: 14, charge: charge_create

        expect(credit.outstanding).to eq(14.00)
      end

      it 'debit reduces the outstanding amount' do
        charge = charge_create
        debit_create amount: 4.00, charge: charge
        credit_create amount: 6.00, charge: charge

        expect(described_class.first.outstanding).to eq(2.00)
      end
    end

    describe '#spent?' do
      it 'false without credit' do
        charge = charge_create
        credit_create amount: 8.00, charge: charge

        expect(described_class.first).not_to be_spent
      end

      it 'true when spent' do
        charge = charge_create
        debit_create amount: 8.00, charge: charge
        credit_create amount: 8.00, charge: charge

        expect(described_class.first).to be_spent
      end
    end
  end
end
