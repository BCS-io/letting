def property_attributes overrides = {}
  {
    human_id: 2002,
    client_id: 8989,
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

def charge_attributes overrides = {}
  {
    charge_type: 'Ground Rent',
    due_in: 'Advance',
    amount: '88.08'
  }.merge overrides
end

def due_on_attributes_0 overrides = {}
  {
    day: 31,
    month: 3
  }.merge overrides
end

def due_on_attributes_1 overrides = {}
  {
    day: 30,
    month: 9
  }.merge overrides
end

def due_on_monthly_attributes_0 overrides = {}
  {
    day: 1,
    month: -1
  }.merge overrides
end

def user_attributes overrides = {}
  {
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password',
    admin: false
  }.merge overrides
end

def admin_attributes overrides = {}
  {
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    admin: true
  }.merge overrides
end

def george_attributes overrides = {}
  {
    email: 'george@ulyett.com',
    password: 'password',
    password_confirmation: 'password',
    admin: true
  }.merge overrides
end

def debt_attributes overrides = {}
  { account_id: 1, debt_generator_id: 1, charge_id: 1, on_date: '2013/1/30', amount: 10.05 }.merge overrides
end

def payment_attributes  overrides = {}
  { account_id: 1, debt_id: 1, on_date: '2013/1/30', amount: 10.05 }.merge overrides
end

def debt_generator_attributes overrides = {}
  { id: 1, search_string: 'Lords', start_date: '2013/3/1', end_date: '2013/4/1' }.merge overrides
end
