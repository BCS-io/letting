######
# UserPage
#
# Encapsulates the User Page
#
# The layer hides the Capybara calls to make the functional rspec tests that
# use this class simpler.
#####
#
class UserPage
  include Capybara::DSL

  def load id: nil
    if id.nil?
      visit '/users/new'
    else
      visit "/users/#{id}/edit"
    end
    self
  end

  def button action
    click_on "#{action} User", exact: true
    self
  end

  def fill_form(nickname, email, password, confirmation = password)
    within_fieldset 'user' do
      fill_in 'Nickname', with: nickname
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: confirmation
    end
  end

  def successful?
    has_content? /created|updated/i
  end

  def errored?
    has_css? '[data-role="error_messages"]'
  end
end
