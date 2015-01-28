require 'rails_helper'

describe 'Session', type: :feature do
  it '#creates' do
    user_create user_attributes
    navigates_to_create_page
    fill_in_login
    expect_to
    logs_out
  end

  it '#creates - fails' do
    navigates_to_create_page
    fill_in_login
    expect_failure
  end

  it 'displays admin panel' do
    user_create role: 'admin'
    navigates_to_create_page
    fill_in_login

    expect(page).to have_text 'Admin'
  end

  def navigates_to_create_page
    visit '/login/'
  end

  def fill_in_login
    within_fieldset 'login' do
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_on 'Log In'
    end
  end

  def expect_to
    expect(current_path).to eq '/'
    expect(page).to have_text /Logged in!/i
    expect(page).to have_text /user/i
  end

  def logs_out
    click_on('logout')
    expect(page).to have_text /Logged out!/i
    expect(page).to have_title 'Letting - Login'
  end

  def expect_failure
    expect(page).to have_title 'Letting - Login'
    expect(page).to have_text 'Email or password is invalid'
  end
end
