
# Seeds Properties
#
# Property             Entity
# id human_ref client  id Type Title Init.  Name
# 1  1001      1       1  Prop Mr    E P    Hendren
# 2  2002      1       2  Prop Mr    M W    Gatting
# 3  3003      2       3  Prop Mr    J W    Hearne
# 4  4004      3       4  Prop Mr    J D B  Robertson

after 'clients', 'agents' do

  class << self
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
        },
      ]
    end

    def create_addresses
      Address.create! [
        {
          addressable_id: 1,
          addressable_type: 'Property',
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
          road_no: '3',
          road: 'Green Fields',
          town: 'Suburbaton',
          county: 'Greater London',
          postcode: 'SG3 3SC'
        },
      ]
    end

    def create_properties
      Property.create! [
        { id: 1, human_ref: 1001, client_id: 1, agent: Agent.find(1) },
        { id: 2, human_ref: 2002, client_id: 1, agent: Agent.find(2) },
        { id: 3, human_ref: 3003, client_id: 2, agent: Agent.find(3) },
        { id: 4, human_ref: 4004, client_id: 3, agent: Agent.find(4) },
      ]
    end
  end

  create_entities
  create_addresses
  create_properties
end