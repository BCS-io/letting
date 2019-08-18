#
# Seeds Client
#
# Clients consist of reference number, entities (only 1 in examples)
# and an address
#
# Client        Entity                            Address
# id  human_ref id  title initials Name           id flat_no house
# 1   1         1   Mr    K S      Ranjitsinhji   1  96      Old Trafford
# 2   2         2   Mr    B        Simpson        2  54      Old Trafford
# 3   3         3   Mr    V        Richards       3  84      Old Trafford

one = Client.new(id: 1, human_ref: 1)
one.entities.build(entitieable_id: 1,
                   entitieable_type: 'Client',
                   title: 'Mr',
                   initials: 'K S',
                   name: 'Ranjitsinhji')
one.build_address(addressable_id: 1,
                  addressable_type: 'Client',
                  flat_no: '96',
                  house_name: 'Old Trafford',
                  road_no: '154',
                  road: 'Talbot Road',
                  district: 'Stretford',
                  town: 'Manchester',
                  county: 'Greater Manchester',
                  postcode: 'M16 0PX')

two = Client.new(id: 2, human_ref: 2)
two.entities.build(entitieable_id: 2,
                   entitieable_type: 'Client',
                   title: 'Mr',
                   initials: 'B',
                   name: 'Simpson')
two.build_address(addressable_id: 2,
                  addressable_type: 'Client',
                  flat_no: '64',
                  house_name: 'Old Trafford',
                  road_no: '311',
                  road: 'Brian Statham Way',
                  district: 'Stretford',
                  town: 'Manchester',
                  county: 'Greater Manchester',
                  postcode: 'M16 0PX')

three = Client.new(id: 3, human_ref: 3)
three.entities.build(entitieable_id: 3,
                     entitieable_type: 'Client',
                     title: 'Mr',
                     initials: 'V',
                     name: 'Richards')
three.build_address(addressable_id: 3,
                    addressable_type: 'Client',
                    flat_no: '84',
                    house_name: 'Old Trafford',
                    road_no: '189',
                    road: 'Great Stone Road',
                    district: 'Stretford',
                    town: 'Manchester',
                    county: 'Greater Manchester',
                    postcode: 'M16 0PX')

Client.transaction do
  one.save!
  two.save!
  three.save!
end
