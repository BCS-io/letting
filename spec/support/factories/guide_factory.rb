def guide_new id: nil,
              invoice_text: nil,
              instruction: 'Your instruction',
              fillin: 'This is useful',
              sample: 'Filled top'
  guide = Guide.new id: id,
                    instruction: instruction,
                    fillin: fillin,
                    sample: sample
  guide.invoice_text = invoice_text || invoice_text_new
  guide
end

def guide_create id: nil,
                 invoice_text: nil,
                 instruction: 'Your instruction',
                 fillin: 'This is useful',
                 sample: 'Filled top'
  guide = guide_new id: id,
                    invoice_text: invoice_text,
                    instruction: instruction,
                    fillin: fillin,
                    sample: sample
  guide.save!
end
