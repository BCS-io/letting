
# Seed for testing Database
# **Any new table** which has rows added should appear in pk reset at bottom.

# this starts seeding off with method call at the end of file
def generate_seeding
  truncate_tables
  seed_clients
  seed_properties
  reset_pk_sequenece_on_each_table_used
end


  def truncate_tables
    Rake::Task['db:truncate_all'].invoke
  end

  def seed_clients
    Entity.create! [
      {
        entitieable_id: 1,
        entitieable_type: 'Client',
        title: 'Mr',
        initials: 'K S',
        name: 'Ranjitsinhji'
      },
      {
        entitieable_id: 2,
        entitieable_type: 'Client',
        title: 'Mr',
        initials: 'B',
        name: 'Simpson'
      },
      {
        entitieable_id: 3,
        entitieable_type: 'Client',
        title: 'Mr',
        initials: 'V',
        name: 'Richards'
      }
    ]
    Address.create! [
      {
        addressable_id: 1,
        addressable_type: 'Client',
        type:     'FlatAddress',
        flat_no:  '96',
        house_name: 'Old Trafford',
        road_no:  '154',
        road:     'Talbot Road',
        district: 'Stretford',
        town:     'Manchester',
        county:   'Greater Manchester',
        postcode: 'M16 0PX'
      },
      {
        addressable_id: 2,
        addressable_type: 'Client',
        type:     'FlatAddress',
        flat_no:  '64',
        house_name: 'Old Trafford',
        road_no:  '311',
        road:     'Brian Statham Way',
        district: 'Stretford',
        town:     'Manchester',
        county:   'Greater Manchester',
        postcode: 'M16 0PX'
      },
      {
        addressable_id: 3,
        addressable_type: 'Client',
        type:     'FlatAddress',
        flat_no:  '84',
        house_name: 'Old Trafford',
        road_no:  '189',
        road:     'Great Stone Road',
        district: 'Stretford',
        town:     'Manchester',
        county:   'Greater Manchester',
        postcode: 'M16 0PX'
      }
    ]

    Client.create! [
      { id: 1, human_id: 1 },
      { id: 2, human_id: 2 },
      { id: 3, human_id: 3 }
    ]
  end



def seed_properties
  create_entities
  create_addresses
  create_properties
  create_billing_profile_entities
  create_billing_profile_addresses
  create_billing_profiles
end

  def create_entities
    Entity.create! [
      {
        entitieable_id: 1,
        entitieable_type: 'Property',
        title: 'Mr',
        initials: 'E P',
        name: 'Hendren'
      },
      {
        entitieable_id: 2,
        entitieable_type: 'Property',
        title: 'Mr',
        initials: 'M W',
        name: 'Gatting'
      },
      {
        entitieable_id: 3,
        entitieable_type: 'Property',
        title: 'Mr',
        initials: 'J W',
        name: 'Hearne'
      },
      {
        entitieable_id: 4,
        entitieable_type: 'Property',
        title: 'Mr',
        initials: 'J D B',
        name: 'Robertson'
      }
    ]
  end

  def create_addresses
    Address.create! [
      {
        addressable_id: 1,
        addressable_type: 'Property',
        type:     'FlatAddress',
        flat_no: '28',
        house_name: 'Lords',
        road_no: '2',
        road: 'St Johns Wood Road',
        town: 'London',
        county: 'Greater London',
        postcode: 'NW8 8QN'
      },
      {
        addressable_id: 2,
        addressable_type: 'Property',
        type:     'FlatAddress',
        flat_no: '31',
        house_name: 'Lords',
        road_no: '2',
        road: 'St Johns Wood Road',
        town: 'London',
        county: 'Greater London',
        postcode: 'NW8 8QN'
      },
      {
        addressable_id: 3,
        addressable_type: 'Property',
        type:     'FlatAddress',
        flat_no: '31',
        house_name: 'Tavern',
        road_no: '2',
        road: 'St Johns Wood Road',
        town: 'London',
        county: 'Greater London',
        postcode: 'NW8 8QN'
      },
      {
        addressable_id: 4,
        addressable_type: 'Property',
        type:     'HouseAddress',
        road_no: '3',
        road: 'Green Fields',
        town: 'Suburbaton',
        county: 'Greater London',
        postcode: 'SG3 3SC'
      }
    ]
  end

  def create_properties
    Property.create! [
      { id: 1, human_id: 1001, client_id: 1 },
      { id: 2, human_id: 2002, client_id: 1 },
      { id: 3, human_id: 3003, client_id: 2 },
      { id: 4, human_id: 4004, client_id: 3 }
     ]
  end


  def create_billing_profile_entities
    Entity.create! [
      {
        entitieable_id: 1,
        entitieable_type: 'BillingProfile',
        title: 'Mr',
        initials: 'J C',
        name: 'Laker'
      }
    ]
  end

  def create_billing_profile_addresses
    Address.create! [
      {
        addressable_id: 1,
        addressable_type: 'BillingProfile',
        type:     'FlatAddress',
        flat_no:  '33',
        house_name: 'The Oval',
        road_no:  '207b',
        road:     'Vauxhall Street',
        district: 'Kennington',
        town:     'London',
        county:   'Greater London',
        postcode: 'SE11 5SS'
      }
    ]
  end

  def create_billing_profiles
    BillingProfile.create! [
      { id: 1, use_profile: true,  property_id: 1 },
      { id: 2, use_profile: false, property_id: 2 },
      { id: 3, use_profile: false, property_id: 3 }
    ]
  end

def reset_pk_sequenece_on_each_table_used
  Rake::Task['db:reset_pk'].invoke
end

generate_seeding
