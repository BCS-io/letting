require 'rails_helper'

RSpec.describe 'User#index', type: :system do
  before(:each) { log_in admin_attributes }

  it 'completes basic' do
    user_create email: 'george@example.com'
    visit '/users/'
    expect(current_path).to eq '/users/'
    expect(page).to have_text 'system@example.com'
    expect(page).to have_text 'george@example.com'
    expect(page).to have_link 'Edit'
  end
end
