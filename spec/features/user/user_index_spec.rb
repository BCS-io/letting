require 'rails_helper'

describe 'User index', type: :feature do
  before(:each) { log_in admin_attributes }
  it 'basic users in view page' do
    user_create email: 'george@example.com'
    visit '/users/'
    expect(current_path).to eq '/users/'
    expect(page).to have_text 'admin@example.com'
    expect(page).to have_text 'george@example.com'
    expect(page).to have_link 'Edit'
  end
end
