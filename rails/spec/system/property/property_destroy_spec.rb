require 'rails_helper'

#
# Property's route path is to account
#
RSpec.describe 'Property#destroy', type: :system do
  before { log_in }

  it 'completes basic' do
    property_create human_ref: 9000, account: account_new
    visit '/accounts'
    expect(page).to have_text '9000'

    expect { click_on 'Delete' }.to change(Property, :count).by(-1)

    expect(page).to have_text '9000'
    expect(page).to have_text 'deleted!'
    expect(page).to have_current_path '/accounts'
  end
end
