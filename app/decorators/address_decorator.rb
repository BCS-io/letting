require_relative '../../lib/modules/method_missing'

#####
#
# AddressDecorator
#
# Adding html and css code to address objects.
#
# AddressDecorator is responsible for adding, or not, js active classes to the
# address object used in property and client.
#
# Decorator initializes viability of objects:
# By default this is district text element hidden and the add button district
# visible. This is reversed once district has been added. The decorator use:
# js-revealable - 'display: none;' to initialize visibility.
#
# Toggling visibility
#
# Add district button has js-toggle class - this reverses visibility of
# elements with the class 'js-togglable' - in this case the district and
# the button element.
#
# Once district has been added to the address the next time the page is opened
# the js-revealable will be set on the 'add button' and not on the text element.
# Result: Text visible and the button invisible.
#
# Structure, Style and Behaviour
#
# html - _address.html.erb
# css - js-toggle, js-togglable, js-revealable
# js - toggle.js
#
#####
#
class AddressDecorator
  include MethodMissing

  def address
    @source
  end

  def initialize address
    @source = address
  end

  def district_visiblity
    address.district? ? '' : 'js-revealable'
  end

  def add_district_visiblity
    address.district? ? 'js-revealable' : ''
  end

  def nation_visiblity
    address.nation? ? '' : 'js-revealable'
  end

  def add_nation_visiblity
    address.nation? ? 'js-revealable' : ''
  end
end
