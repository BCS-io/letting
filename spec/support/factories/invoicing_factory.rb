def invoicing_new id: nil,
                  property_range: '1-100',
                  period: '2014/06/30'..'2014/08/30',
                  runs: [run_new(invoicing: nil)]
  invoicing = Invoicing.new id: id,
                            property_range: property_range
  invoicing.period = period
  invoicing.runs = runs if runs
  invoicing
end

def invoicing_create id: nil,
                     property_range: '1-100',
                     period: '2014/06/30'..'2014/08/30',
                     runs: [run_new(invoicing: nil)]
  invoicing = Invoicing.new id: id,
                            property_range: property_range
  invoicing.period = period
  invoicing.runs = runs if runs
  invoicing.save!
  invoicing
end
