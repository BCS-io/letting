################################
# Account Page
#
# Encapsulates the Account Page (new and edit)
#
# The layer hides the capybara calls to make the functional rspec tests that
# use this class simpler.
#
# Due to Address methods
# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength
#
class AccountPage
  include Capybara::DSL

  def load id: nil
    if id.nil?
      visit '/accounts/new'
    else
      visit "/accounts/#{id}/edit"
    end
    self
  end

  def button action
    click_on "#{action} Account", exact: true
    self
  end

  def delete_charge
    click_on 'Delete Charge', exact: true
  end

  # expect values in property
  #  - property_id the property's id
  #  - client_id the client's id
  #
  #  Note: we select visual text and expect index id's
  #
  def expect_property(spec, property_id:, client_id:)
    spec.expect(find_field('Property ID').value).to spec.have_text property_id
    spec.expect(find_field('Client ID').value).to spec.have_text client_id
  end

  # set property values
  #  - property_id - database index's id
  #  - client_ref - the human readable id of the client
  #      where client ref != client_id
  #  Note: we select visual text and expect index id's
  #
  def property(property_id:, client_ref:)
    fill_in 'Property ID', with: property_id
    select(client_ref, from: 'Client ID')
  end

  def expect_entity(spec, type:, order: 0, title: '', initials: '', name:)
    id_stem = "#{type}_entities_attributes_#{order}"
    spec.expect(find_field("#{id_stem}_title").value).to spec.have_text title
    spec.expect(find_field("#{id_stem}_initials").value).to \
      spec.have_text initials
    spec.expect(find_field("#{id_stem}_name").value).to spec.have_text name
  end

  def entity(type:, order: 0, title:, initials:, name:)
    id_stem = "#{type}_entities_attributes_#{order}"
    fill_in "#{id_stem}_title", with: title
    fill_in "#{id_stem}_initials", with: initials
    fill_in "#{id_stem}_name", with: name
  end

  def expect_address(spec, type:, address:)
    within type do
      spec.expect(find_field('Flat no').value).to spec.have_text address.flat_no
      spec.expect(find_field('House name').value)
        .to spec.have_text address.house_name
      spec.expect(find_field('Road no').value).to spec.have_text address.road_no
      spec.expect(find_field('Road').value).to spec.have_text address.road
      spec.expect(find_field('Town').value).to spec.have_text address.town
      spec.expect(find_field('District').value)
        .to spec.have_text address.district if address.district.present?
      spec.expect(find_field('County').value).to spec.have_text address.county
      spec.expect(find_field('Postcode').value)
        .to spec.have_text address.postcode
    end
  end

  def address(selector:, address:)
    within selector do
      fill_in 'Flat no', with: address.flat_no
      fill_in 'House name', with: address.house_name
      fill_in 'Road no', with: address.road_no
      fill_in 'Road', with: address.road
      fill_in 'District', with: address.district if address.district.present?
      fill_in 'Town', with: address.town
      fill_in 'County', with: address.county
      fill_in 'Postcode', with: address.postcode
    end
  end

  def charge(order: 0, charge:)
    id_stem = "property_account_attributes_charges_attributes_#{order}"
    fill_in "#{id_stem}_charge_type", with: charge.charge_type
    select charge.cycle.name, from: "#{id_stem}_cycle_id"
    select charge.payment_type.humanize, from: "#{id_stem}_payment_type"
    fill_in "#{id_stem}_amount", with: charge.amount
  end

  def expect_charge order: 0
    charge = Charge.new
    id_stem = "property_account_attributes_charges_attributes_#{order}"
    charge.charge_type = find_field("#{id_stem}_charge_type").value
    charge.cycle_id = find_field("#{id_stem}_cycle_id").value
    charge.amount = find_field("#{id_stem}_amount").value
    charge
  end

  def successful? spec
    spec.expect(page.title).to spec.eq 'Letting - Accounts'
    spec.expect(page).to spec.have_text(/created|updated/i)
    self
  end
end
