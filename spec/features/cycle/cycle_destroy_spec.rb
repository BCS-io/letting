require 'rails_helper'

RSpec.describe 'Cycle#destroy', :ledgers, type: :feature do
  before { log_in admin_attributes }

  it 'destroys' do
    cycle_create id: 3, name: 'Jan', order: 6, cycle_type: 'term'
    visit '/cycles/'

    expect(page.title).to eq 'Letting - Cycles'
    expect(page).to have_text 'Jan'

    expect { click_on 'Delete' }.to change(Cycle, :count).by(-1)

    expect(page).to have_text 'Jan'
    expect(page).to have_text 'deleted'

    expect(page.title).to eq 'Letting - Cycles'
  end
end
