require 'rails_helper'

RSpec.describe 'Permission Testing', type: :system do
  it 'allows a guest to use login route' do
    visit '/login'
    expect(page.title).to eq 'Letting - Login'
  end

  it "does not allow a guest to use an application's controller" do
    visit '/accounts'
    expect(page.title).to eq 'Letting - Login'
  end

  it "does not allow a user to access an administrator's controller" do
    log_in
    visit '/users'
    expect(page.title).to eq 'Letting - Login'
  end

  it "allows an admin to access an administrator's controller" do
    log_in admin_attributes
    visit '/users'
    expect(page.title).to eq 'Letting - Users'
  end

  it 'resets session when user missing' do
    log_in
    User.first.destroy
    visit '/users'
    expect(page.title).to eq 'Letting - Login'
  end
end
