jQuery ->
  $('#search').autocomplete
    source: '/search_suggestions'

  $('#property_address_attributes_house_name,
     #property_address_attributes_road,
     #property_address_attributes_town,
     #property_address_attributes_county,
     #property_agent_attributes_address_attributes_house_name,
     #property_agent_attributes_address_attributes_road,
     #property_agent_attributes_address_attributes_town,
     #property_agent_attributes_address_attributes_county,
     #property_charges_attributes_0_charge_type,
     #property_charges_attributes_1_charge_type,
     #property_charges_attributes_2_charge_type,
     #property_charges_attributes_3_charge_type').each (index, element) =>
     $(element).autocomplete
      source: $(element).data('autocomplete-source')

