def client_new(
  id: nil,
  human_ref: 354,
  address: address_new,
  entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')],
  properties: nil
)
  client = Client.new id: id,
                      human_ref: human_ref,
                      address: address,
                      entities: entities
  client.properties << properties if properties
  client
end

def client_create(
  id: nil,
  human_ref: 354,
  address: address_new,
  entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')],
  properties: nil
)
  client = client_new id: id,
                      human_ref: human_ref,
                      address: address,
                      entities: entities,
                      properties: properties
  client.save!
  client
end
