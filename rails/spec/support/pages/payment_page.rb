######
# PaymentPage
#
# Encapsulates the PaymentPage
#
# The layer hides the Capybara calls to make the functional rspec tests use
# a higher level of abstraction.
# http://robots.thoughtbot.com/acceptance-tests-at-a-single-level-of-abstraction
#
#####
#
class PaymentPage
  include Capybara::DSL

  def load id: nil
    if id.nil?
      visit '/payments/new'
    else
      visit "/payments/#{id}/edit"
    end
    self
  end

  def human_ref property
    fill_in 'account_payment_search', with: property
    self
  end

  def booked_at
    find_field('payment_booked_at').value
  end

  def booked_at= date
    fill_in 'payment_booked_at', with: date
  end

  def credit= amount
    fill_in 'payment_credits_attributes_0_amount', with: amount
  end

  def credit
    find_field('payment_credits_attributes_0_amount').value.to_d
  end

  def payment
    find_field('payment_amount').value.to_d
  end

  def search
    click_on 'Payment Search', exact: true
    self
  end

  def pay
    click_on 'submit', exact: true
    self
  end

  # has_search?
  # faster to test data-role is missing than negating empty_search?
  # has_no_css - does not wait for timeout to decide
  #              that the role is missing.
  #
  def populated_search?
    has_no_css? '[data-role="unknown-property"]'
  end

  def empty_search?
    has_css? '[data-role="unknown-property"]'
  end

  def receivables?
    has_css? '[data-role="receivables"]'
  end

  def errored?
    has_css? '[data-role="error_messages"]'
  end

  def successful?
    has_content? /created|updated/i
  end
end
