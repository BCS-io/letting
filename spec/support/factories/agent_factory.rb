def agent_new(
  authorized: true,
  address: address_new,
  entities: [Entity.new(title: 'Mr', initials: 'M', name: 'Prior')]
)
  Agent.new authorized: authorized, address: address, entities: entities
end
