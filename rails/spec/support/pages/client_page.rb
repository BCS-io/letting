################################
# Client Page
#
# Encapsulates the Client Page (new and edit)
#
# The layer hides the Capybara calls to make the functional RSpec tests that
# use this class simpler.
#
# rubocop: disable Metrics/ParameterLists
#
class ClientPage
  include Capybara::DSL

  def load id: nil
    if id.nil?
      visit '/clients/new'
    else
      visit "/clients/#{id}/edit"
    end
    self
  end

  def button action
    click_on "#{action} Client", exact: true
    self
  end

  def click choice
    click_on choice, exact: true
  end

  def fill_in_client_id client_id
    fill_in 'Client ID', with: client_id
  end

  def fill_in_entity(order:, title: '', initials: '', name:)
    id_stem = "client_entities_attributes_#{order}"
    fill_in "#{id_stem}_title", with: title
    fill_in "#{id_stem}_initials", with: initials
    fill_in "#{id_stem}_name", with: name
  end

  def fill_in_address(flat_no:, house_name:, road_no:, road:,
                      town:, district:, county:, postcode:)
    fill_in 'Flat no', with: flat_no
    fill_in 'House name', with: house_name
    fill_in 'Road no', with: road_no
    fill_in 'Road', with: road
    fill_in 'Town', with: town
    fill_in 'District', with: district
    fill_in 'County', with: county
    fill_in 'Postcode', with: postcode
  end

  def ref
    find_field('Client ID').value.to_i
  end

  def entity(order:)
    id_stem = "client_entities_attributes_#{order}"
    "#{find_field("#{id_stem}_title").value} " \
    "#{find_field("#{id_stem}_initials").value} " \
    "#{find_field("#{id_stem}_name").value}".strip
  end

  def town
    find_field('Town').value
  end

  def successful?
    has_content? /created|updated/i
  end
end
