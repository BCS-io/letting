# rubocop: disable Metrics/MethodLength
# rubocop: disable Metrics/ParameterLists

def cycle_new id: nil,
                  name: 'Mar',
                  charged_in: charged_in_create,
                  order: 1,
                  cycle_type: 'term',
                  due_ons: [DueOn.new(day: 25, month: 3)],
                  prepare: false
  cycle = Cycle.new id: id,
                    name: name,
                    charged_in: charged_in,
                    order: order,
                    cycle_type: cycle_type
  cycle.due_ons = due_ons if due_ons
  cycle.charged_in = charged_in if charged_in
  cycle.prepare if prepare
  cycle
end

def cycle_create id: 1,
                     name: 'Mar',
                     charged_in: charged_in_create,
                     order: 1,
                     cycle_type: 'term',
                     due_ons: [DueOn.new(day: 25, month: 3)],
                     prepare: false
  cycle = cycle_new id: id,
                    name: name,
                    charged_in: charged_in,
                    order: order,
                    cycle_type: cycle_type,
                    due_ons: due_ons,
                    prepare: prepare
  cycle.save!
  cycle
end

def cycle_monthly_create id: 1,
                         name: 'First',
                         charged_in: charged_in_create,
                         order: 1,
                         cycle_type: 'monthly',
                         day: 1,
                         prepare: false
  cycle = Cycle.new id: id,
                    name: name,
                    charged_in_id: charged_in,
                    order: order,
                    cycle_type: cycle_type
  (1..12).each { |month| cycle.due_ons << [DueOn.new(day: day, month: month)] }
  cycle.charged_in = charged_in if charged_in
  cycle.prepare if prepare
  cycle.save!
  cycle
end
