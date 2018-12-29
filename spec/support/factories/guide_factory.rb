def guide_new id: nil,
              invoice_text_id: '2',
              instruction: 'Your instruction',
              fillin: 'This is useful',
              sample: 'Filled top'
  Guide.new id: id,
            invoice_text_id: invoice_text_id,
            instruction: instruction,
            fillin: fillin,
            sample: sample
end

def guide_create id: nil,
                 invoice_text_id: '2',
                 instruction: 'Your instruction',
                 fillin: 'This is useful',
                 sample: 'Filled top'
  Guide.create! id: id,
                invoice_text_id: invoice_text_id,
                instruction: instruction,
                fillin: fillin,
                sample: sample
end
