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
# Temporary until start_date / end_date used
# rubocop: disable Lint/UnusedMethodArgument
#
class AccountPage
  include Capybara::DSL

  def new
    visit '/accounts/new'
    self
  end

  def edit
    visit '/accounts/'
    click_on 'Edit Account', exact: true
    self
  end

  def button action
    click_on "#{action} Account", exact: true
    self
  end

  def click choice
    click_on choice, exact: true
  end

  def expect_property(spec, property_id:, client_id:)
    spec.expect(find_field('Property ID').value).to spec.have_text property_id
    spec.expect(find_field('property_client_ref').value).to spec.have_text \
      client_id
  end

  def property(spec, property_id:, client_id:)
    fill_in 'Property ID', with: property_id
    spec.fill_autocomplete('property_client_ref', with: client_id)
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

  def charge(order: 0, charge: nil, delete: false)
    id_stem = "property_account_attributes_charges_attributes_#{order}"
    if charge
      fill_in "#{id_stem}_charge_type", with: charge.charge_type
      select charge.cycle.name, from: "#{id_stem}_cycle_id"
      select charge.payment_type.humanize, from: "#{id_stem}_payment_type"
      fill_in "#{id_stem}_amount", with: charge.amount
    end

    find(:xpath, "//*[@id='#{id_stem}__destroy']").click  if delete
  end

  def expect_charge spec, order: 0, charge: charge
    id_stem = "property_account_attributes_charges_attributes_#{order}"
    spec.expect(find_field("#{id_stem}_charge_type").value)
      .to spec.have_text charge.charge_type
    spec.expect(find_field("#{id_stem}_cycle_id"))
      .to spec.have_text charge.cycle.name
    spec.expect(find_field("#{id_stem}_amount").value)
      .to spec.have_text charge.amount
  end

  def successful? spec
    spec.expect(page.title).to spec.eq 'Letting - Accounts'
    spec.expect(page).to spec.have_text /created|updated/i
    self
  end
end
