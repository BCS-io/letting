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
    Rake::Task['db:import:charged_ins'].invoke
    create_cycle

    Charge.create! [
      { id: 1, charge_type: 'Ground Rent',    cycle_id: 1, amount: '88.08',  account_id: 1 },
      { id: 2, charge_type: 'Service Charge', cycle_id: 1, amount: '125.08', account_id: 1 },
      { id: 3, charge_type: 'Ground Rent',    cycle_id: 1, amount: '70.00',  account_id: 2 },
      { id: 4, charge_type: 'Service Charge', cycle_id: 1, amount: '70.00',  account_id: 3 },
    ]
  end

  def create_cycle
    DueOn.create! [
      { id: 1,  day: 25,  month: 3, cycle_id: 1 },
      { id: 2,  day: 29,  month: 9, cycle_id: 1 },
      { id: 3,  day: 25,  month: 6, cycle_id: 2 },
      { id: 4,  day: 29,  month: 12, cycle_id: 2 },
    ]
    Cycle.create! [
      { id: 1,  name: 'Mar/Sep', charged_in_id: 1, order: 1, cycle_type: 'term' },
      { id: 2,  name: 'Jun/Dec', charged_in_id: 1, order: 2, cycle_type: 'term' },
    ]
    Cycle.all.each { |cycle| Cycle.reset_counters(cycle.id, :due_ons) }
  end
end

create_charges
