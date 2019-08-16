require 'rails_helper'

RSpec.describe 'Cycle#create', :ledgers, type: :system do
  before { log_in admin_attributes }

  context 'when Term' do
    it 'creates a cycle' do
      cycle_page = CyclePage.new type: :term
      cycle_page.load
      expect(cycle_page.title).to eq 'Letting - New Term Cycle'
      cycle_page.name = 'April'
      cycle_page.choose 'Advance'
      cycle_page.order = '44'
      cycle_page.due_on month: 4, day: 10, show_month: 3, show_day: 11
      cycle_page.button 'Create Cycle'
      expect(cycle_page).to be_success
    end

    it 'displays form errors' do
      cycle_page = CyclePage.new type: :term
      cycle_page.load
      cycle_page.button 'Create Cycle'
      expect(cycle_page).to be_errored
    end
  end

  context 'when Monthly' do
    it 'creates a cycle' do
      cycle_page = CyclePage.new type: :monthly
      cycle_page.load
      expect(cycle_page.title).to eq 'Letting - New Monthly Cycle'
      cycle_page.name = 'Monthly'
      cycle_page.choose 'Arrears'
      cycle_page.order = '44'
      cycle_page.due_on day: 10, month: 0
      cycle_page.button 'Create Cycle'
      expect(cycle_page).to be_success
    end

    it 'displays form errors' do
      cycle_page = CyclePage.new type: :monthly
      cycle_page.load
      cycle_page.button 'Create Cycle'
      expect(cycle_page).to be_errored
    end
  end
end
