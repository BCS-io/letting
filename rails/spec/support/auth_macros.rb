####
#
# AuthMacros
#
# functional tests require that the test user logs in to the system.
# These macros allow all functional tests to login.
#  - Included through the rails helper
#
####
#
module AuthMacros
  def log_in **attributes
    current_user = User.create! user_attributes attributes
    visit '/login/'
    login_form current_user
    expect(page).to have_content 'Logged in'
  end

  def login_form current_user
    within_fieldset 'login' do
      fill_in 'Email',    with: current_user.email
      fill_in 'Password', with: current_user.password
      click_on 'Log In'
    end
  end
end
