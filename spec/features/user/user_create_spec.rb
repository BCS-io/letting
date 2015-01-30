require 'rails_helper'

describe 'User#create', type: :feature do
  let(:user_page) { UserPage.new }
  before(:each) { log_in admin_attributes }

  it 'creates a user' do
    user_page.load

    user_page.fill_form 'newuser', 'newuser@example.com', 'password', 'password'
    user_page.button action: 'Create'
    expect(user_page).to be_successful
    expect(page).to have_text 'newuser@example.com'
  end

  it 'displays form errors' do
    user_page.load

    user_page.button action: 'Create'
    expect(user_page).to be_errored
  end
end
