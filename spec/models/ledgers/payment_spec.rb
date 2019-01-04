require 'rails_helper'

RSpec.describe Payment, :payment, :ledgers, type: :model do
  describe 'validates' do
    it('is valid') { expect(payment_new account: account_new).to be_valid }
    it 'requires account' do
      expect(payment_new(account_id: nil)).to_not be_valid
    end
    describe 'amount' do
      it('requires amount') { expect(payment_new amount: nil).to_not be_valid }
      it('is a number') { expect(payment_new amount: 'nan').to_not be_valid }
      it('has a max') { expect(payment_new amount: 100_000).to_not be_valid }
      it 'is valid under max' do
        expect(payment_new account: account_new, amount: 99_999.99).to be_valid
      end
      it('has a min') { expect(payment_new amount: -100_000).to_not be_valid }
      it 'is valid under min' do
        expect(payment_new account: account_new, amount: -99_999.99).to be_valid
      end
      it('fails zero amount') { expect(payment_new amount: 0).to_not be_valid }
    end
    it 'requires date' do
      payment = payment_new
      # note: default_initialization for booked_at
      payment.booked_at = nil
      expect(payment).to_not be_valid
    end
  end

  describe 'initialize' do
    # changing for Date to DateTime - so I want test to fail if we use date
    describe 'booked_at' do
      it 'sets nil booked_at to today' do
        Timecop.freeze(Time.zone.local(2013, 9, 30, 2, 0)) do
          expect(payment_new(booked_at: nil).booked_at)
            .to eq Time.zone.now
        end
      end
    end
    describe 'amount' do
      it 'sets nil amount to 0' do
        expect(payment_new(amount: nil).amount).to eq 0
      end
      it 'leaves defined amounts intact' do
        payment = payment_create account: account_new, amount: 10.50
        expect(Payment.find(payment.id).amount).to eq(10.50)
      end
    end
  end

  describe '#register_booking' do
    # changing for Date to DateTime - so I want test to fail if we use date

    it 'booking time is current time if booking today' do
      Timecop.freeze(Time.zone.local(2013, 9, 30, 2, 0)) do
        payment = payment_new account: account_new,
                              booked_at: Time.zone.local(2013, 9, 30, 10, 0)

        payment.register_booking

        expect(payment.booked_at)
          .to eq Time.zone.local(2013, 9, 30, 2, 0)
      end
    end

    it 'booking time set to end of day if booking in past' do
      payment = payment_new account: account_new,
                            booked_at: Time.zone.local(2013, 9, 29, 10, 0)
      payment.register_booking

      expect(payment.booked_at)
        .to be_within(5.seconds)
        .of(Time.zone.local(2013, 9, 29, 23, 59, 59, 999_999))
    end

    it 'booking time set to start of day if booking in future' do
      Timecop.freeze(Time.zone.local(2013, 9, 30, 2, 0)) do
        payment = payment_new account: account_new,
                              booked_at: Time.zone.local(2013, 10, 1, 10, 0)

        payment.register_booking

        expect(payment.booked_at)
          .to be_within(5.seconds)
          .of(Time.zone.local(2013, 10, 1, 0, 0, 0))
      end
    end
  end

  describe 'methods' do
    describe '#account_exists?' do
      it 'true if account known' do
        (payment = payment_new).account = Account.new id: 100
        expect(payment).to be_account_exists
      end

      it 'false if no account' do
        (payment = payment_new).account = nil
        expect(payment).to_not be_account_exists
      end
    end

    describe '#prepare' do
      it 'handles no credits' do
        (payment = payment_new).account = account_new
        payment.prepare
        expect(payment.credits.size).to eq(0)
      end
      it 'adds returned credits' do
        (payment = payment_new).account = account_new
        allow(payment.account).to receive(:charges).and_return [charge_new]
        payment.prepare
        expect(payment.credits.size).to eq(1)
      end
    end

    describe 'validation' do
      it 'removes credits with no amounts' do
        (payment = payment_new credit: credit_new(amount: 0)).valid?
        expect(payment.credits.first).to be_marked_for_destruction
      end

      it 'saves credits with none-zero amount' do
        (payment = payment_new credit: credit_new(amount: 1)).valid?
        expect(payment.credits.first).to_not be_marked_for_destruction
      end
    end

    describe '.booked_on' do
      it 'returns payments on queried day' do
        account = account_create property: property_new
        payment = payment_create account_id: account.id,
                                 booked_at: '2014-9-1 16:29:30'
        expect(Payment.booked_on(date: '2014-09-01').to_a).to eq [payment]
      end

      it 'returns nothing on days without a transaction.' do
        account = account_create property: property_new
        payment_create account_id: account.id
        expect(Payment.booked_on(date: '2000-1-1').to_a).to eq []
      end

      it 'returns nothing if invalid date' do
        account = account_create property: property_new
        payment_create account_id: account.id
        expect(Payment.booked_on date: '2012-x').to eq []
      end
    end

    describe '.recent' do
      it 'returns payments within range' do
        account = account_create property: property_new
        payment = payment_create account_id: account.id,
                                 booked_at: Time.zone.now - 2.years + 1.day

        expect(Payment.recent.to_a).to eq [payment]
      end

      it 'ignores payments outside range' do
        account = account_create property: property_new
        payment_create account_id: account.id,
                       booked_at: Time.zone.now - 2.years - 1.day

        expect(Payment.recent.to_a).to eq []
      end
    end

    describe '.last_booked_at' do
      it 'returns today if no payments at all (unlikely)' do
        expect(Payment.last_booked_at).to eq Time.zone.today.to_s
      end

      it 'returns the last day a payment was made' do
        payment_create(account: account_new, booked_at: '2014-03-25')
        payment_create(account: account_new, booked_at: '2014-06-25')
        expect(Payment.last_booked_at).to eq '2014-06-25'
      end
    end

    describe '.human_ref' do
      it 'returns if in range' do
        payment_create \
          booked_at: '30/4/2013 01:00:00 +0100',
          account: account_create(property: property_new(human_ref: 10))
        payments = Payment.human_ref 10
        expect(payments.size).to eq 1
      end

      it 'returns nothing out of range' do
        payment_create \
          booked_at: '30/4/2013 01:00:00 +0100',
          account: account_create(property: property_new(human_ref: 10))
        payments = Payment.human_ref 5
        expect(payments.size).to eq 0
      end
    end

    describe '.by_quarter_day' do
      it 'returns payments within payment period' do
        payment = payment_create \
          booked_at: Time.zone.local(2013, 2, 1, 0, 0),
          account: account_create(property: property_new(human_ref: 10))

        expect(Payment.by_quarter_day(
                 year: 2013,
                 batch_months: BatchMonths.make(month: BatchMonths::MAR)
               ))
          .to eq [payment]
      end

      it 'returns payments within payment period' do
        payment = payment_create \
          booked_at: Time.zone.local(2013, 7, 31, 23, 59),
          account: account_create(property: property_new(human_ref: 10))

        expect(Payment.by_quarter_day(
                 year: 2013,
                 batch_months: BatchMonths.make(month: BatchMonths::MAR)
               ))
          .to eq [payment]
      end

      it 'rejects payments before payment period' do
        payment_create \
          booked_at: Time.zone.local(2013, 1, 31, 23, 59),
          account: account_create(property: property_new(human_ref: 10))

        expect(Payment.by_quarter_day(
                 year: 2013,
                 batch_months: BatchMonths.make(month: BatchMonths::MAR)
               ))
          .to eq []
      end

      it 'rejects payments after payment period' do
        payment_create \
          booked_at: Time.zone.local(2013, 8, 1, 0, 0),
          account: account_create(property: property_new(human_ref: 10))

        expect(Payment.by_quarter_day(
                 year: 2013,
                 batch_months: BatchMonths.make(month: BatchMonths::MAR)
               ))
          .to eq []
      end
    end
  end

  it 'should be indexed', elasticsearch: true do
    expect(Payment.__elasticsearch__.index_exists?).to be_truthy
  end

  describe 'full text .search', elasticsearch: true do
    it 'human id' do
      payment_create account: account_create(property: property_new(human_ref: 203))
      Payment.import force: true, refresh: true

      expect(Payment.search('203', sort: 'human_ref').results.total).to eq 1
    end

    it 'has amount' do
      payment_create account: account_create(property: property_new), amount: 12.70
      Payment.import force: true, refresh: true

      expect(Payment.search('12.7', sort: 'human_ref').results.total).to eq 1
    end

    it 'has amount to two decimal places' do
      skip
      payment_create account: account_create(property: property_new), amount: 12.70
      Payment.import force: true, refresh: true

      # note this should match but doesn't
      expect(Payment.search('12.70', sort: 'human_ref').results.total).to eq 1
    end

    it 'has holder' do
      payment_create account: account_create(property: \
        property_new(occupiers: [Entity.new(name: 'Strauss')]))
      Payment.import force: true, refresh: true

      expect(Payment.search('Strauss', sort: 'human_ref').results.total).to eq 1
    end

    it 'has property address' do
      payment_create account: \
          account_create(property: property_new(address: address_new(town: 'Bristol')))
      Payment.import force: true, refresh: true

      expect(Payment.search('Bristol', sort: 'human_ref').results.total).to eq 1
    end
  end
end
