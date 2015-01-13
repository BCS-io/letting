# rubocop:disable LineLength
require 'rails_helper'

describe 'PrintScreenShow', type: :feature do
  describe '#show' do
    it 'basic' do
      charge = charge_new charge_type: ChargeTypes::GROUND_RENT
      setup snapshot: snapshot_new(debits: [debit_new(charge: charge)])
      visit '/prints_screens/1'

      expect(page).to have_text 'Low'
      expect(page).to have_text '30/06/2014'
    end

    describe 'back page is used for Ground Rents & Garage Ground Rents only' do
      it 'displays back page with garage ground rent, uses invoice_text 2' do
        charge = charge_new charge_type: ChargeTypes::GARAGE_GROUND_RENT
        setup snapshot: snapshot_new(debits: [debit_new(charge: charge)])
        visit '/prints_screens/1'

        # TODO: write page wrapper
        # Tests showing the page has been loaded
        expect(page).to have_text 'Act 2002'
      end

      it 'is left blank without ground rent' do
        charge = charge_new charge_type: ChargeTypes::INSURANCE
        setup snapshot: snapshot_new(debits: [debit_new(charge: charge)])
        visit '/prints_screens/1'

        # TODO: write page wrapper
        # Tests showing the page has been loaded
        expect(page).to_not have_text 'Act 2002'
      end
    end

    def setup(snapshot:)
      log_in admin_attributes
      invoice_text_create id: 1,
                          invoice_name: 'Hattie',
                          address: address_new(road: 'Low')
      invoice_text_create id: 2, heading1: 'Act 2002'
      (1..7).each { |guide_id| guide_create id: guide_id, instruction: 'inst' }

      property = property_create(human_ref: 1984,
                                 occupiers: [Entity.new(name: 'Smiths')])

      run_create id: 1, invoices: [invoice_create(property: property, snapshot: snapshot)]
    end
  end
end
