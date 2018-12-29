# rubocop: disable Metrics/ParameterLists

def property_new \
  id: nil,
  human_ref: 2002,
  occupiers: [Entity.new(title: 'Mr', initials: 'W G', name: 'Grace')],
  address: address_new,
  account: nil,
  client: client_new,
  agent: nil,
  prepare: false

  property = Property.new id: id, human_ref: human_ref
  property.client = client if client
  property.prepare_for_form if prepare
  property.address = address
  property.entities = occupiers if occupiers
  property.account = account if account
  property.build_agent authorized: false
  property.agent = agent if agent
  property
end

def property_create \
  id: nil,
  human_ref: 2002,
  occupiers: [Entity.new(title: 'Mr', initials: 'W G', name: 'Grace')],
  address: address_new,
  account: nil,
  client: client_create,
  agent: nil,
  prepare: false

  property = property_new id: id,
                          human_ref: human_ref,
                          occupiers: occupiers,
                          address: address,
                          account: account,
                          client: client,
                          agent: agent,
                          prepare: prepare
  property.save!
  property
end
