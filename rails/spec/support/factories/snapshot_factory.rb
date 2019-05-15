def snapshot_new id: nil,
                 account: nil,
                 period: '2000/01/01'..'2000/03/01',
                 debits: [debit_new(charge: charge_new)]
  snapshot = Snapshot.new id: id, period: period
  snapshot.account = (account || account_new)
  snapshot.debited debits: debits if debits
  snapshot
end

def snapshot_create id: nil,
                    account: nil,
                    period: '2000/01/01'..'2000/03/01',
                    debits: [debit_new(charge: charge_new)]
  snapshot = snapshot_new id: id,
                          account: account,
                          period: period,
                          debits: debits
  snapshot.save!
end
