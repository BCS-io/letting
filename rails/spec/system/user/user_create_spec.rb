require 'rails_helper'

RSpec.describe 'User#create', type: :system do
  let(:user_page) { UserPage.new }
  before(:each) { log_in admin_attributes }

  it 'creates a user' do
    user_page.load

    user_page.fill_form 'newuser', 'newuser@example.com', 'password', 'password'
    user_page.button 'Create'
    expect(user_page).to be_successful
    expect(page).to have_text 'newuser@example.com'
  end

  it 'displays form errors' do
    user_page.load

    user_page.button 'Create'
    expect(user_page).to be_errored
  end
end
