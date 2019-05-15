
def run_new id: nil,
            invoicing: invoicing_new,
            invoices: [invoice_new]
  run = Run.new id: id
  run.invoicing = invoicing if invoicing
  run.invoices = invoices if invoices
  run
end

def run_create id: nil,
               invoicing: invoicing_new,
               invoices: [invoice_new]
  run = run_new id: id,
                invoicing: invoicing,
                invoices: invoices
  run.save!
  run
end
