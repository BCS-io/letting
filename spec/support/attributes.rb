def property_attributes overrides = {}
  {
    human_ref: 2002,
    client_id: 8989,
  }.merge overrides
end

def agent_attributes overrides = {}
  {
    authorized: true,
    property_id: 1,
  }.merge overrides
end

def client_attributes overrides = {}
  {
    human_ref: 8008,
  }.merge overrides
end

def min_address_attributes overrides = {}
  {
    road:     'Edgbaston Road',
    town:     'Birmingham',
    county:   'West Midlands',
  }.merge overrides
end

def address_attributes overrides = {}
  {
    flat_no:  '47',
    house_name: 'Hillbank House',
    road_no:  '294',
    road:     'Edgbaston Road',
    district: 'Edgbaston',
    town:     'Birmingham',
    county:   'West Midlands',
    postcode: 'B5 7QU'
  }.merge overrides
end

def house_address_attributes overrides = {}
  {
    road_no:  '294',
    road:     'Edgbaston Road',
    district: 'Edgbaston',
    town:     'Birmingham',
    county:   'West Midlands',
    postcode: 'B5 7QU'
  }.merge overrides
end

def oval_address_attributes overrides = {}
  {
    flat_no:  '33',
    house_name: 'The Oval',
    road_no:  '207b',
    road:     'Vauxhall Street',
    district: 'Kennington',
    town:     'London',
    county:   'Greater London',
    postcode: 'SE11 5SS'
  }.merge overrides
end

def person_entity_attributes overrides = {}
  {
    entity_type: 'Person',
    title: 'Mr',
    initials: 'W G',
    name: 'Grace'
  }.merge overrides
end

def company_entity_attributes overrides = {}
  {
    entity_type: 'Company',
    title: '',
    initials: '',
    name: 'ICC'
  }.merge overrides
end

def oval_person_entity_attributes overrides = {}
  {
    entity_type: 'Person',
    title: 'Rev',
    initials: 'V W',
    name: 'Knutt'
  }.merge overrides
end

def user_attributes overrides = {}
  {
    nickname: 'user',
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password',
    admin: false
  }.merge overrides
end

def admin_attributes overrides = {}
  {
    nickname: 'admin',
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    admin: true
  }.merge overrides
end

def george_attributes overrides = {}
  {
    nickname: 'george',
    email: 'george@ulyett.com',
    password: 'password',
    password_confirmation: 'password',
    admin: true
  }.merge overrides
end
