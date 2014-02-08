def property_new args = {}
  property = base_property args
  add_no_agent property
  property
end

def property_create! args = {}
  (property = property_new args).save!
  property
end

def property_with_agent_create! args = {}
  property = base_property args
  add_agent property
  property.save!
  property
end

def property_with_charge_new args = {}
  property = base_property args
  add_no_agent property
  add_charge property
  property
end

def property_with_charge_create! args = {}
  (property = property_with_charge_new args).save!
  property
end

def property_with_monthly_charge_create! args = {}
  property = base_property args
  add_no_agent property
  charge = property.account.charges.build charge_attributes
  charge.due_ons.build due_on_monthly_attributes_0
  property.save!
  property
end

# when your running full specs I haven't found reliable way of guaranteeing
# a primary key will be set to a value. This is a hack to save the object
# get the key value and put it into the debit - not nice
def property_with_charge_and_unpaid_debit args = {}
  (property = property_with_charge_new).save!
  property.account.debits.build debit_attributes \
    charge_id: property.account.charges.first.id
  property
end

def property_with_unpaid_debit args = {}
  property = base_property args
  add_debit_attribute property.account, args
  property
end

private

def base_property args = {}
  property = Property.new property_attributes args
  property.prepare_for_form
  property.build_address address_attributes args.fetch(:address_attributes, {})
  property.entities.build person_entity_attributes
  property
end

def add_no_agent bill_me
  bill_me.build_agent authorized: false
end

def add_agent bill_me
  bill_me.build_agent authorized: true
  bill_me.agent.build_address oval_address_attributes
  bill_me.agent.entities.build oval_person_entity_attributes
end

def add_charge charge_me
  charge = charge_me.account.charges.build charge_attributes
  add_due_on_0 charge
  add_due_on_1 charge
end

def add_due_on_0 charge
  charge.due_ons.build due_on_attributes_0
end

def add_due_on_1 charge
  charge.due_ons.build due_on_attributes_1
end

def add_debit_attribute account, args
  account.debits.build debit_attributes args.fetch(:debit_attributes, {})
end
