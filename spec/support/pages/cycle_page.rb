################################
# CyclePage
#
# Encapsulates the Cycle Page (new and edit)
#
# The layer hides the Capybara calls to make the functional rspec tests that
# use this class simpler.
#
# rubocop: disable Metrics/ParameterLists
#
class CyclePage
  include Capybara::DSL
  attr_reader :type

  def initialize type: :term
    @type = type
  end

  def load id: nil
    if id.nil?
      visit "/cycles/new?cycle_type=#{type}"
    else
      visit "/cycles/#{id}/edit"
    end
    self
  end

  def button action
    click_on action, exact: true
    self
  end

  def name= value
    fill_in 'Name', with: value
  end

  def charged_in charged_in
    choose charged_in
  end

  def order= value
    fill_in 'Order', with: value
  end

  def due_on order: 0, day:, month:, year: nil, show_month: nil, show_day: nil
    if type == :term
      fill_in "#{id_stem order}_day", with: day
      fill_in "#{id_stem order}_month", with: month
      fill_in "#{id_stem order}_year", with: year
      fill_in "#{id_stem order}_show_month", with: show_month if show_month
      fill_in "#{id_stem order}_show_day", with: show_day if show_day
    else
      fill_in 'day', with: day
    end
    self
  end

  def errored?
    has_css? '[data-role="error_messages"]'
  end

  def success?
    has_content? /created|updated/i
  end

  private

  def id_stem order
    "cycle_due_ons_attributes_#{order}"
  end
end
