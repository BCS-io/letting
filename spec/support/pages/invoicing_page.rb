#####
#
# InvoicingPage
#
# Encapsulates the page so tests can work at a higher abstraction than Capybara
# will allow.
#
class InvoicingPage
  include Capybara::DSL

  def load invoicing: nil
    if invoicing.nil?
      visit '/invoicings/new'
    else
      visit "/invoicings/#{invoicing.id}/edit"
    end
    self
  end

  def search_term term
    fill_in 'Property range', with: term
    self
  end

  def search
    click_on 'Search'
    self
  end

  def choose_dates
    click_on 'or choose dates'
    self
  end

  def or_default
    click_on 'or default to the next 7 weeks'
    self
  end

  def invoice_date
    find_field('invoice_date').value
  end

  def invoice_date= date
    fill_in 'invoice_date', with: date
    self
  end

  def period
    find_field('Start date').value..find_field('End date').value
  end

  def period=(range)
    fill_in 'Start date', with: range.first
    fill_in 'End date', with: range.last
    self
  end

  def form
    # fieldset id
    find('#invoicing')
  end

  def button action
    click_on "#{action} Invoicing", exact: true
    self
  end

  def errored?
    has_css? '[data-role="error_messages"]'
  end

  def success?
    has_content? /created|updated/i
  end

  def actionable?
    has_content? /Deliver/i
  end

  def not_actionable?
    has_content? /has no account that can be charged for the period./i
  end

  def none_delivered?
    has_content? /No invoices will be delivered./i
  end

  def none_retained?
    has_content? /No invoices will be retained./i
  end

  def none_ignored?
    has_content? /No invoices will be ignored./i
  end

  def excluded?
    has_content? /does not match any accounts./i
  end
end
