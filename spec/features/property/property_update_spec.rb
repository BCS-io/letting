require 'spec_helper'
require_relative '../shared/address'
require_relative '../shared/entity'

describe Property do

  it '#updates' do
    property_factory id: 1, human_property_id: 8000
    navigate_to_edit_page
    validate_page
    expect_form_to_be
    fill_in_form
    click_on 'Update Property'
    expect_properties_page
    navigate_to_property_page
    expect_property_updates
  end

  it '#update handles validation' do
    property_factory id: 1, human_property_id: 8000
    navigate_to_edit_page
    validate_page
    check_use_billing_profile
    clear_address_road
    click_on 'Update Property'
    expect(current_path).to eq '/properties/1'
    expect(page).to have_text 'The property could not be saved.'
  end

  def navigate_to_edit_page
    visit '/properties/'
    click_on 'Edit'
  end

  def validate_page
    expect(current_path).to eq '/properties/1/edit'
  end

  def expect_form_to_be
    expect_property_has_original_attributes
    expect_address_has_original_attributes
    expect_entity_has_original_attributes
    expect_bill_profile_has_original_attributes
  end

    def expect_property_has_original_attributes
      expect(find_field('property_human_property_id').value).to have_text '8000'
    end

    def expect_address_has_original_attributes
      within_fieldset 'property_address' do
        expect_address_edgbaston_by_field
      end
    end

    def expect_entity_has_original_attributes
      within_fieldset 'property_entity_0' do
        expect_entity_wg_grace_by_field
      end
    end

    def expect_bill_profile_has_original_attributes
      within_fieldset 'billing_profile' do
        # As long as text for one field is right we know the
        # partial already works in other address code
        expect(find_field('Flat no').value).to have_text '33'
      end
    end



  def fill_in_form
    fill_in 'property_human_property_id', with: '8001'
    fill_in_address
    fill_in_entity
    fill_in_bill_profile
  end

    def fill_in_client_address
      within_fieldset 'client_address' do
        fill_in_address_nottingham
      end
    end


    def fill_in_address
      within_fieldset 'property_address' do
        fill_in_address_nottingham
      end
    end

    def fill_in_entity
      within_fieldset 'property_entity_0' do
        fill_in_entity_dc_compto
      end
    end

    def fill_in_bill_profile
      check_use_billing_profile
      fill_in_bill_profile_address
      fill_in_bill_profile_entity
    end

      def check_use_billing_profile
        within_fieldset 'billing_profile' do
          check 'Use profile'
        end
      end

      def fill_in_bill_profile_address
        within_fieldset 'billing_profile' do
          fill_in 'Road', with: 'Middlesex Road'
        end
      end

      def fill_in_bill_profile_entity
        within_fieldset 'property_billing_profile_entity_0' do
          fill_in 'Initials', with: 'G A R'
          fill_in 'Name', with: 'Lock'
        end
      end

  def navigate_to_property_page
    visit '/properties/1'
  end

  def expect_properties_page
    expect(current_path).to eq '/properties'
    expect(page).to have_text 'Property successfully updated!'
    expect_property_data_changed
  end

    def expect_property_data_changed
      expect(page).to_not have_text '8000'
      expect(page).to have_text '8001'
      expect(page).to_not have_text '294'
      expect(page).to have_text '471'
    end



  def expect_property_updates
    expect_new_address
    expect_new_entity
    expect_new_bill_profile
  end

    def expect_new_address
      expect_address_nottingham
    end

    def expect_new_entity
      expect_entity_dc_compton
    end

    def expect_new_bill_profile
      expect(page).to have_text 'Middlesex Road'
      expect(page).to have_text 'G A R'
      expect(page).to have_text 'Lock'
    end

  def clear_address_road
    within_fieldset 'property_address' do
      fill_in 'Road', with: ''
    end
  end

end