# rubocop: disable Metrics/MethodLength
# rubocop: disable Metrics/ParameterLists

def account_new id: nil,
                property: nil,
                property_id: 18_305,
                charges: nil,
                credits: nil,
                debits: nil,
                payment: nil
  account = Account.new id: id
  if property
    account.property = property
  else
    account.property_id = property_id
  end
  account.charges << charges if charges
  account.credits << credits if credits
  account.debits = debits if debits
  account.payments << payment if payment
  account
end

def account_create id: nil,
                   property: nil,
                   property_id: 18_306,
                   charges: nil,
                   credits: nil,
                   debits: nil,
                   payment: nil
  account = account_new id: id,
                        property: property,
                        property_id: property_id,
                        charges: charges,
                        credits: credits,
                        debits: debits,
                        payment: payment
  account.save!
  account
end
