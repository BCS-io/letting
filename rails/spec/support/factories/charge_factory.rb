# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def charge_new id: nil,
               account_id: 2,
               charge_type: ChargeTypes::GROUND_RENT,
               amount: 88.08,
               activity: 'active',
               payment_type: 'manual',
               cycle: cycle_new,
               credits: nil,
               debits: nil

  charge = Charge.new id: id,
                      account_id: account_id,
                      charge_type: charge_type,
                      payment_type: payment_type,
                      amount: amount,
                      activity: activity,
                      cycle: cycle
  charge.cycle = cycle if cycle
  charge.credits = credits if credits
  charge.debits = debits if debits
  charge
end

def charge_find_or_create id: nil,
                          account_id: 2,
                          charge_type: ChargeTypes::GROUND_RENT,
                          payment_type: 'manual',
                          amount: 88.08,
                          activity: 'active',
                          cycle: cycle_new,
                          credits: nil,
                          debits: nil
  Charge.find_by(id: id) || charge_create(id: id,
                                          account_id: account_id,
                                          charge_type: charge_type,
                                          payment_type: payment_type,
                                          amount: amount,
                                          activity: activity,
                                          cycle: cycle,
                                          credits: credits,
                                          debits: debits)
end

def charge_create id: nil,
                  account_id: 2,
                  charge_type: ChargeTypes::GROUND_RENT,
                  payment_type: 'manual',
                  amount: 88.08,
                  activity: 'active',
                  cycle: cycle_create,
                  credits: nil,
                  debits: nil

  charge = charge_new id: id,
                      account_id: account_id,
                      charge_type: charge_type,
                      payment_type: payment_type,
                      amount: amount,
                      activity: activity,
                      cycle: cycle,
                      credits: credits,
                      debits: debits
  charge.save!
  charge
end
