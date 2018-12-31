require 'rails_helper'

RSpec.describe 'Cycle#index', :ledgers, type: :feature do
  before { log_in admin_attributes }

  it 'completes basic' do
    cycle_create id: 1, name: 'Jan', order: 6, cycle_type: 'term'
    visit '/cycles/'

    expect(page.title).to eq 'Letting - Cycles'

    expect(page).to have_text 'Jan'
    expect(page).to have_text '6'
  end

  it 'has ordered list' do
    cycle_create id: 2, name: 'Feb', order: 2
    visit '/cycles/'
    first(:link, 'Edit').click
    expect(find_field('Name').value).to have_text 'Feb'
    expect(find_field('Order').value).to have_text '2'
  end
end
