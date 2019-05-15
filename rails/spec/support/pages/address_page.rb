######
# AddressPage
#
# Encapsulates the Address Page (new/create/edit/update)
#
# The layer hides the Capybara calls to make the functional rspec tests that
# use this class simpler.
#####
#
class AddressPage
  include Capybara::DSL

  def add(line:)
    click_on "Add #{line}", exact: true
  end

  def delete(line:)
    click_on "Delete #{line}", exact: true
  end

  # t-district - only used for spec testing
  #
  def district_visible?
    has_css?('.t-district', visible: true)
  end

  # t-district - only used for spec testing
  # has_no_css does not wait for timeout.
  #
  def district_invisible?
    has_no_css?('.t-district', visible: true)
  end

  def add_nation
    click_on 'Add a nation line to the address', exact: true
  end

  # t-nation only used for spec testing
  #
  def nation_visible?
    has_css?('.t-nation', visible: true)
  end

  # t-nation only used for spec testing
  # has_no_css does not wait for timeout.
  #
  def nation_invisible?
    has_no_css?('.t-nation', visible: true)
  end
end
