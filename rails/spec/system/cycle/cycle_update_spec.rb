require 'rails_helper'

RSpec.describe 'Cycle#update', :ledgers, type: :system do
  before { log_in admin_attributes }

  context 'when Term' do
    it 'edits term' do
      cycle_create id: 1,
                   name: 'Mar',
                   charged_in: 'arrears',
                   cycle_type: 'term',
                   due_ons: [DueOn.new(month: 3, day: 25)]
      cycle_page = CyclePage.new type: :term

      cycle_page.load id: 1
      expect(cycle_page.title).to eq 'Letting - Edit Cycle'
      cycle_page.name = 'Jun/Dec'
      cycle_page.choose 'Arrears'
      cycle_page.order = '44'
      cycle_page.due_on month: 6, day: 24
      cycle_page.button 'Update Cycle'

      expect(cycle_page).to be_success
      expect(Cycle.first.name).to eq 'Jun/Dec'
    end
  end

  context 'when Monthly' do
    it 'edits monthly' do
      cycle_create id: 1,
                   name: 'Regular',
                   charged_in: 'arrears',
                   cycle_type: 'monthly',
                   due_ons: [DueOn.new(month: 1, day: 8)],
                   prepare: true
      cycle_page = CyclePage.new type: :monthly

      cycle_page.load id: 1
      expect(page).to have_text 'Monthly'
      cycle_page.name = 'New Monthly'
      cycle_page.choose 'Arrears'
      cycle_page.order = '21'
      cycle_page.due_on day: 12, month: 0
      cycle_page.button 'Update Cycle'

      expect(cycle_page).to be_success
      expect(Cycle.first.name).to eq 'New Monthly'
    end
  end

  it 'aborts on Cancel' do
    cycle_create id: 1
    cycle_page = CyclePage.new

    cycle_page.load id: 1
    cycle_page.button 'Cancel'
    expect(cycle_page.title).to eq 'Letting - Cycles'
  end

  it 'can error' do
    cycle_create id: 1, name: 'Jan/July'

    cycle_page = CyclePage.new
    cycle_page.load id: 1
    cycle_page.name = ''
    cycle_page.button 'Update Cycle'
    expect(cycle_page).to be_errored
  end
end
