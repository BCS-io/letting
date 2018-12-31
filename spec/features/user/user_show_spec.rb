require 'rails_helper'

RSpec.describe 'User#show', type: :feature do
  before(:each) do
    log_in admin_attributes
  end

  it 'completes basic' do
    user_create nickname: 'other', email: 'other@example.com'
    visit '/users/'
    expect(current_path).to eq '/users/'
    first('.link-view-testing', visible: false).click
    expect(page).to have_text 'other@example.com'
    expect(page).to have_text 'other'
  end
end
