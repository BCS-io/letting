# rubocop: disable Metrics/ParameterLists

def address_new flat_no: '',
                house_name: '',
                road_no: '',
                road: 'Edgbaston Road',
                district: '',
                town: 'Birmingham',
                county: 'West Midlands',
                postcode: '',
                nation: ''
  base_address flat_no: flat_no,
               house_name: house_name,
               road_no: road_no,
               road: road,
               district: district,
               town: town,
               county: county,
               postcode: postcode,
               nation: nation
end

def base_address(flat_no:,
                 house_name:,
                 road_no:,
                 road:,
                 district:,
                 town:,
                 county:,
                 postcode:,
                 nation:)
  Address.new flat_no: flat_no,
              house_name: house_name,
              road_no: road_no,
              road: road,
              district: district,
              town: town,
              county: county,
              postcode: postcode,
              nation: nation
end
