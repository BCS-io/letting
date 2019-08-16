require 'rails_helper'

RSpec.describe 'Cycle#create', :ledgers, type: :system do
  before { log_in admin_attributes }

  context 'when Term' do
    it 'adds due date', js: true do
      cycle_page = CyclePage.new type: :term
      cycle_create id: 1, due_ons: [DueOn.new(month: 3, day: 25)]
      expect(Cycle.first.due_ons.count).to eq 1

      cycle_page.load id: 1
      expect(cycle_page.title).to eq 'Letting - Edit Cycle'
      cycle_page.button 'Add Due Date'
      cycle_page.due_on order: 1, month: 9, day: 29
      cycle_page.button 'Update Cycle'

      expect(cycle_page).to be_success
      expect(Cycle.first.due_ons.count).to eq 2
    end

    it 'removes due_date', js: true do
      cycle_page = CyclePage.new type: :term
      cycle_create id: 1, due_ons: [DueOn.new(month: 6, day: 24),
                                    DueOn.new(month: 12, day: 25)]
      expect(Cycle.first.due_ons.count).to eq 2

      cycle_page.load id: 1
      expect(cycle_page.title).to eq 'Letting - Edit Cycle'
      cycle_page.button 'Delete Due Date'
      cycle_page.button 'Update Cycle'

      expect(cycle_page).to be_success
      expect(Cycle.first.due_ons.count).to eq 1
    end
  end
end
