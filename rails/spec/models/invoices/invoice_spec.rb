# rubocop: disable  Metrics/LineLength
require 'rails_helper'
require_relative '../../../lib/modules/charge_types'
include ChargeTypes

RSpec.describe Invoice, type: :model do
  it('is valid') { expect(invoice_new).to be_valid }
  describe 'validates presence' do
    it('property_ref') do
      expect(invoice_new property: property_new(human_ref: nil)).to_not be_valid
    end
    it('invoice_date') { expect(invoice_new invoice_date: nil).to_not be_valid }
    it 'property_address' do
      (invoice = Invoice.new).property_address = nil
      expect(invoice).to_not be_valid
    end
  end

  describe 'when child invoices destroyed' do
    it 'destroys associated snapshot if it has no surviving child invoices' do
      snapshot = snapshot_new(account: account_new)
      property = property_create
      invoice = invoice_create snapshot: snapshot, property: property

      expect { invoice.destroy }.to change(Snapshot, :count).by(-1)
    end

    it 'preserves associated snapshot while account still has other' \
       'surviving child invoices' do
      snapshot = snapshot_new(account: account_new)
      property = property_create
      invoice_create snapshot: snapshot, property: property
      invoice = invoice_create snapshot: snapshot, property: property

      expect { invoice.destroy }.to change(Snapshot, :count).by(0)
    end
  end

  describe 'methods' do
    describe '#prepare' do
      it 'prepares invoice_date' do
        invoice_text_create id: 1
        property = property_create account: account_new
        snapshot = Snapshot.new(account: property.account)
        snapshot.period_first = '2000-01-01'

        (invoice = Invoice.new).prepare property: property.invoice,
                                        snapshot: snapshot,
                                        color: :blue,
                                        invoice_date: '2014-06-30'

        expect(invoice.invoice_date.to_s).to eq '2014-06-30'
      end

      it 'sets property_ref' do
        invoice_text_create id: 1
        invoice = Invoice.new
        property = property_create human_ref: 55, account: account_new
        snapshot = Snapshot.new(account: property.account)
        snapshot.period_first = '2000-01-01'

        invoice.prepare property: property.invoice,
                        snapshot: snapshot,
                        color: :blue

        expect(invoice.property_ref).to eq 55
      end

      it 'sets billing_address' do
        invoice_text_create id: 1
        invoice = Invoice.new
        agent = agent_new(entities: [Entity.new(name: 'Lock')])
        property = property_create agent: agent, account: account_new
        snapshot = Snapshot.new(account: property.account)
        snapshot.period_first = '2000-01-01'

        invoice.prepare property: property.invoice,
                        snapshot: snapshot,
                        color: :blue

        expect(invoice.billing_address).to eq "Lock\nEdgbaston Road\nBirmingham\nWest Midlands"
      end

      it 'prepares invoice products' do
        invoice_text_create id: 1
        property = property_create account: account_new
        debit = debit_new(period: '2010-09-30'..'2011-03-25',
                          amount: 30.05,
                          charge: charge_new(charge_type: GROUND_RENT))

        (invoice = Invoice.new).prepare property: property.invoice,
                                        snapshot: snapshot_new(account: property.account,
                                                               debits: [debit]),
                                        color: :blue

        expect(invoice.products.first.to_s)
          .to eq 'charge_type: Ground Rent date_due: 2013-03-25 amount: 30.05 '\
                 'period: 2010-09-30..2011-03-25, balance: 30.05'
      end

      describe '#earliest_date_due' do
        it 'finds the earliest' do
          invoice_text_create id: 1
          property = property_create account: account_new
          debit = debit_create at_time: '2000-01-01', charge: charge_new

          (invoice = Invoice.new).prepare property: property.invoice,
                                          snapshot: snapshot_new(account: property.account,
                                                                 debits: [debit]),
                                          color: :blue,
                                          invoice_date: '2014-06-30'
          expect(invoice.earliest_date_due).to eq Date.new(2000, 1, 1)
        end

        it 'ignores the earlier arrears date' do
          invoice_text_create id: 1
          arrears = debit_create at_time: '1999-01-01', charge: charge_new
          debit = debit_create at_time: '2000-01-01', charge: charge_new

          property = property_create account: account_new(debits: [arrears, debit])

          invoice = Invoice.new
          invoice.prepare property: property.invoice,
                          snapshot: snapshot_new(account: property.account,
                                                 period: '2000/01/01'..'2000/03/01',
                                                 debits: [debit]),
                          color: :blue,
                          invoice_date: '2014-06-30'
          expect(invoice.earliest_date_due).to eq Date.new(2000, 1, 1)
        end

        it 'returns arrears date if nothing else is available' do
          invoice_text_create id: 1
          arrears = debit_create at_time: '1999-01-01', charge: charge_new

          property = property_create account: account_new(debits: [arrears])

          invoice = Invoice.new
          invoice.prepare property: property.invoice,
                          snapshot: snapshot_new(account: property.account,
                                                 period: '2000/01/01'..'2000/03/01',
                                                 debits: []),
                          color: :blue,
                          invoice_date: '2014-06-30'
          expect { invoice.earliest_date_due }.to raise_error Invoice::InvoiceMissingProducts
        end
      end

      it 'prepares invoice total_arrears' do
        invoice = Invoice.new
        invoice.products = [product_new(balance: 10)]

        expect(invoice.total_arrears).to eq 10
      end

      describe 'comments' do
        it 'prepares without comments' do
          invoice_text_create id: 1
          property = property_create account: account_new
          snapshot = Snapshot.new(account: property.account)
          snapshot.period_first = '2000-01-01'

          (invoice = Invoice.new).prepare property: property.invoice,
                                          snapshot: snapshot,
                                          color: :blue

          expect(invoice.comments.size).to eq 0
        end

        it 'prepares with comments' do
          invoice_text_create id: 1
          property = property_create account: account_new
          snapshot = Snapshot.new(account: property.account)
          snapshot.period_first = '2000-01-01'

          (invoice = Invoice.new).prepare property: property.invoice,
                                          snapshot: snapshot,
                                          color: :blue,
                                          comments: ['comment']

          expect(invoice.comments.size).to eq 1
          expect(invoice.comments.first.clarify).to eq 'comment'
        end

        it 'ignores empty comments' do
          invoice_text_create id: 1
          property = property_create account: account_new
          snapshot = Snapshot.new(account: property.account)
          snapshot.period_first = '2000-01-01'

          (invoice = Invoice.new).prepare property: property.invoice,
                                          snapshot: snapshot,
                                          color: :blue,
                                          comments: ['comment', '']

          expect(invoice.comments.size).to eq 1
        end
      end
    end

    describe '#page2?' do
      it 'returns false if products have no ground rent' do
        invoice = invoice_new
        invoice.products = [product_new(charge_type: INSURANCE)]

        snapshot = Snapshot.new invoices: [invoice]

        expect(snapshot.invoices.first.page2?).to eq false
      end

      it 'returns true if products includes ground rent' do
        invoice = invoice_new
        invoice.products = [product_new(charge_type: GROUND_RENT)]

        snapshot = Snapshot.new invoices: [invoice]

        expect(snapshot.invoices.first.page2?).to eq true
      end

      it 'returns false if on a red invoice' do
        debit = debit_new charge: charge_new(charge_type: GROUND_RENT)
        snapshot = Snapshot.new invoices: [invoice_new, invoice_new], debits: [debit]
        snapshot.period_first = '2000-01-01'

        invoice = invoice_new snapshot: snapshot

        expect(invoice.page2?).to eq false
      end
    end

    describe '#actionable?' do
      it 'returns true if in debt' do
        invoice = Invoice.new deliver: 'mail'

        expect(invoice).to be_actionable
      end

      it 'returns false if not in debt' do
        invoice = Invoice.new deliver: 'forget'

        expect(invoice).to_not be_actionable
      end
    end

    it 'outputs #to_s' do
      expect(invoice_new.to_s.lines.first)
        .to start_with %q(Billing Address: "Mr W. G. Grace\nEdgbaston Road\nBirmingham\nWest Midlands")
    end
  end
end
