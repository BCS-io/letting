def letter_new id: nil,
               invoice_id: nil,
               invoice_text_id: 1
  Letter.new id: id,
             invoice_id: invoice_id,
             invoice_text_id: invoice_text_id
end

def letter_create id: nil,
                  invoice_id: 1,
                  invoice_text_id: 1
  Letter.create! id: id,
                 invoice_id: invoice_id,
                 invoice_text_id: invoice_text_id
end
