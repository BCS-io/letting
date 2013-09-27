def property_factory args = {}
  property = Property.new property_attributes args
  property.prepare_for_form
  add_contact property, args
  add_no_billing_profile property
  property.save!
  property
end

def property_factory_with_billing args = {}
  property = Property.new property_attributes id: args[:id]
  property.human_id = args[:human_id] if args[:human_id].present?
  property.prepare_for_form
  add_contact property, args
  add_billing_profile property
  add_charge property
  property.save!
  property
end

def property_factory_with_charge args = {}
  property = Property.new property_attributes id: args[:id]
  property.human_id = args[:human_id] if args[:human_id].present?
  property.prepare_for_form
  add_contact property, args
  add_no_billing_profile property
  add_charge property
  property.save!
  property
end


def add_no_billing_profile bill_me
  bill_me.build_billing_profile use_profile: false
end

def add_billing_profile bill_me
  bill_me.build_billing_profile use_profile: true
  bill_me.billing_profile.build_address oval_address_attributes
  bill_me.billing_profile.entities.build oval_person_entity_attributes
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



def property_factory_with_monthly_charge args = {}
  property = Property.new property_attributes id: args[:id]
  property.human_id = args[:human_id] if args[:human_id].present?
  property.prepare_for_form
  add_contact property, args
  add_no_billing_profile property
  charge = property.account.charges.build charge_attributes
  charge.due_ons.build due_on_monthly_attributes_0
  property.save!
  property
end
