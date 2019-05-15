#
#  Charge                            Join  Cycle                 DueOn
#  id type            Amount  AccId  Ref   id  name     Charged  id  month day
#  1  Ground Rent      88.08  1     1001   1   Mar/Sep  Arrears  1   3      25
#                                                                2   9      29
#  2  Service Charge  125.08  1     1001   1   Mar/Sep  Arrears  1   3      25
#                                                                2   9      29
#  3  Ground Rent      70.00  2     2002   1   Mar/Sep  Arrears  1   3      25
#                                                                2   9      29
#  4  Service Charge   70.00  3     3003   1   Mar/Sep  Arrears  1   3      25
#                                                                2   9      29
#

class << self
  def create_charges
    create_cycle

    Charge.create! [
      { id: 1, charge_type: 'Ground Rent',    cycle_id: 1, payment_type: 'manual', amount: '88.08',  account_id: 1 },
      { id: 2, charge_type: 'Service Charge', cycle_id: 1, payment_type: 'automatic', amount: '125.08', account_id: 1 },
      { id: 3, charge_type: 'Ground Rent',    cycle_id: 1, payment_type: 'manual', amount: '70.00',  account_id: 2 },
      { id: 4, charge_type: 'Service Charge', cycle_id: 1, payment_type: 'automatic', amount: '70.00',  account_id: 3 },
    ]
  end

  def create_cycle
    DueOn.create! [
      { id: 1, month: 3,  day: 25, cycle_id: 1 },
      { id: 2, month: 9,  day: 29, cycle_id: 1 },
      { id: 3, month: 6,  day: 25, cycle_id: 2 },
      { id: 4, month: 12, day: 29, cycle_id: 2 },
      { id: 5, month: 4,  day: 1,  cycle_id: 3 },
    ]
    Cycle.create! [
      { id: 1,  name: 'Mar/Sep', charged_in: 'arrears', order: 1, cycle_type: 'term' },
      { id: 2,  name: 'Jun/Dec', charged_in: 'arrears', order: 2, cycle_type: 'term' },
      { id: 3,  name: 'Apr',     charged_in: 'arrears', order: 3, cycle_type: 'term' },
    ]
    Cycle.all.each { |cycle| Cycle.reset_counters(cycle.id, :due_ons) }
  end
end

create_charges
