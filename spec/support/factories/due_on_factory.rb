# rubocop: disable Metrics/ParameterLists

def due_on_new id: nil,
               year: '',
               month: 3,
               day: 25,
               show_month: nil,
               show_day: nil,
               cycle_id: 3
  DueOn.new id: id,
            year: year,
            month: month,
            day: day,
            show_month: show_month,
            show_day: show_day,
            cycle_id: cycle_id
end

def due_on_create id: nil,
                  year: '',
                  month: 3,
                  day: 25,
                  show_month: nil,
                  show_day: nil,
                  cycle_id: 3
  due_on = due_on_new(id: id,
                      year: year,
                      month: month,
                      day: day,
                      show_month: show_month,
                      show_day: show_day,
                      cycle_id: cycle_id)
  due_on.save!
  due_on
end
