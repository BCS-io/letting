require 'rails_helper'

RSpec.describe 'Cycle#show', :ledgers, type: :system do
  before { log_in admin_attributes }

  it 'has basic details' do
    cycle_create id: 3,
                 name: 'Jan',
                 cycle_type: 'term',
                 due_ons: [DueOn.new(month: 1, day: 6)]
    visit '/cycles/3'

    expect(page.title).to eq 'Letting - View Cycle'
    expect(page).to have_text 'Jan'
  end

  it 'has monthly details' do
    cycle_create id: 2,
                 name: 'Every Month',
                 cycle_type: 'monthly',
                 due_ons: [DueOn.new(month: 5, day: 4)],
                 prepare: true
    visit '/cycles/2'

    expect(page.title).to eq 'Letting - View Cycle'
    expect(page).to have_text 'Every Month'
  end
end
