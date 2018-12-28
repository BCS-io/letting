# Attributes are for initilizing test objects.
#
# rubocop: disable Metrics/MethodLength

def address_attributes **overrides
  {
    flat_no:    '47',
    house_name: 'Hillbank House',
    road_no:    '294',
    road:       'Edgbaston Road',
    district:   'Edgbaston',
    town:       'Birmingham',
    county:     'West Midlands',
    postcode:   'B5 7QU'
  }.merge overrides
end

def oval_address_attributes **overrides
  {
    flat_no:    '33',
    house_name: 'The Oval',
    road_no:    '207b',
    road:       'Vauxhall Street',
    district:   'Kennington',
    town:       'London',
    county:     'Greater London',
    postcode:   'SE11 5SS'
  }.merge overrides
end

def person_entity_attributes **overrides
  {
    title: 'Mr',
    initials: 'W G',
    name: 'Grace'
  }.merge overrides
end

def person_attributes **overrides
  {
    title: 'Mr',
    initials: 'W G',
    name: 'Grace'
  }.merge overrides
end

def company_attributes **overrides
  {
    title: '',
    initials: '',
    name: 'ICC'
  }.merge overrides
end

def oval_person_entity_attributes **overrides
  {
    title: 'Rev',
    initials: 'V W',
    name: 'Knutt'
  }.merge overrides
end

def user_attributes **overrides
  {
    nickname: 'user',
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'user'
  }.merge overrides
end

def admin_attributes **overrides
  {
    nickname: 'system',
    email: 'system@example.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'admin'
  }.merge overrides
end

def invoice_text_attributes **overrides
  {
    id: 1,
    description: 'Page 1',
    invoice_name: 'Estates Ltd',
    phone: '0121345678',
    vat: '123 1234 12',
    heading1: 'Head1',
    heading2: 'Head2',
    advice1: 'Good Speed',
    advice2: 'Lock you door',
  }.merge overrides
end

def invoice_text_p2_attributes **overrides
  {
    id: 2,
    description: 'Page 2',
    invoice_name: 'No_go',
    phone: '0121345678',
    vat: '123 1234 12',
    heading1: 'Page2 head1',
    heading2: 'Page2 head2',
    advice1: 'Bowled Out!',
    advice2: 'Oomf'
  }.merge overrides
end
