require 'rails_helper'

#
# Property's route path is to account
#
RSpec.describe 'Property#index', type: :feature do
  before(:each) { log_in }

  it 'basic' do
    client = client_create
    property_create human_ref: 111, client: client, account: account_new
    property_create human_ref: 222, client: client, account: account_new
    property_create human_ref: 333, client: client, account: account_new

    visit '/accounts/'
    # shows more than one row
    expect(page).to have_text '111'
    expect(page).to have_text '222'

    # Displays expected columns
    expect(page).to have_text '333'
    expect_index_address
  end

  def expect_index_address
    [
      'Edgbaston Road', # Road
      'Birmingham'      # Town
    ].each do |line|
      expect(page).to have_text line
    end
  end
end
