#
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

class << self
  def create_agent_entities
    Entity.create! [
      {
        entitieable_id: 1,
        entitieable_type: 'Agent',
        title: 'Mr',
        initials: 'J C',
        name: 'Laker'
      }
    ]
  end

  def create_agent_addresses
    Address.create! [
      {
        addressable_id: 1,
        addressable_type: 'Agent',
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

  def create_agents
    Agent.create! [
      { id: 1, authorized: true,  property_id: 1 },
      { id: 2, authorized: false, property_id: 2 },
      { id: 3, authorized: false, property_id: 3 },
      { id: 4, authorized: false, property_id: 4 }
    ]
  end
end

create_agent_entities
create_agent_addresses
create_agents
