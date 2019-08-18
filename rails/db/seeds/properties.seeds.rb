# Seeds Properties
#
# Property             Entity
# id human_ref client  id Type Title Init.  Name
# 1  1001      1       1  Prop Mr    E P    Hendren
# 2  2002      1       2  Prop Mr    M W    Gatting
# 3  3003      2       3  Prop Mr    J W    Hearne
# 4  4004      3       4  Prop Mr    J D B  Robertson

# Agents
#
# Agents are the people who work on behalf of the tenant
#                               (join)    (join)
# Agent                         Entity    Property   Address
# id  Authorized  property_id   name      ref        first line
# 1   true        1             Laker     1001       28 Lords
# 2   false       2                       2002       31 Lords
# 3   false       3                       3003       31 Tavern
# 4   false       4                       4004        3 Green Fields
#
# TODO: Agent should prevent referenced property being nil, however the foreign
#       key is not doing that.
#

after 'clients' do
  one = Property.new(id: 1, human_ref: 1001, client_id: 1)
  one.entities.build(entitieable_id: 1,
                     entitieable_type: 'Property',
                     title: 'Mr',
                     initials: 'E P',
                     name: 'Hendren')
  one.build_address(addressable_id: 1,
                    addressable_type: 'Property',
                    flat_no: '28',
                    house_name: 'Lords',
                    road_no: '2',
                    road: 'St Johns Wood Road',
                    town: 'London',
                    county: 'Greater London',
                    postcode: 'NW8 8QN')
  agent_one = one.build_agent(id: 1, authorized: true)
  agent_one.entities.build(entitieable_id: 1,
                           entitieable_type: 'Agent',
                           title: 'Mr',
                           initials: 'J C',
                           name: 'Laker')
  agent_one.build_address(addressable_id: 1,
                          addressable_type: 'Agent',
                          flat_no: '33',
                          house_name: 'The Oval',
                          road_no: '207b',
                          road: 'Vauxhall Street',
                          district: 'Kennington',
                          town: 'London',
                          county: 'Greater London',
                          postcode: 'SE11 5SS')

  two = Property.new(id: 2, human_ref: 2002, client_id: 1)
  two.entities.build(entitieable_id: 2,
                     entitieable_type: 'Property',
                     title: 'Mr',
                     initials: 'M W',
                     name: 'Gatting')
  two.build_address(addressable_id: 2,
                    addressable_type: 'Property',
                    flat_no: '31',
                    house_name: 'Lords',
                    road_no: '2',
                    road: 'St Johns Wood Road',
                    town: 'London',
                    county: 'Greater London',
                    postcode: 'NW8 8QN')
  two.build_agent(id: 2, authorized: false)

  three = Property.new(id: 3, human_ref: 3003, client_id: 2)
  three.entities.build(entitieable_id: 3,
                       entitieable_type: 'Property',
                       title: 'Mr',
                       initials: 'J W',
                       name: 'Hearne')
  three.build_address(addressable_id: 3,
                      addressable_type: 'Property',
                      flat_no: '31',
                      house_name: 'Tavern',
                      road_no: '2',
                      road: 'St Johns Wood Road',
                      town: 'London',
                      county: 'Greater London',
                      postcode: 'NW8 8QN')
  three.build_agent(id: 3, authorized: false)

  four = Property.new(id: 4, human_ref: 4004, client_id: 3)
  four.entities.build(entitieable_id: 4,
                      entitieable_type: 'Property',
                      title: 'Mr',
                      initials: 'J D B',
                      name: 'Robertson')
  four.build_address(addressable_id: 4,
                     addressable_type: 'Property',
                     road_no: '3',
                     road: 'Green Fields',
                     town: 'Suburbaton',
                     county: 'Greater London',
                     postcode: 'SG3 3SC')
  four.build_agent(id: 4, authorized: false)

  Property.transaction do
    one.save!
    two.save!
    three.save!
    four.save!
  end
end
