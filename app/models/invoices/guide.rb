###
#
# Guide
#
# Guide deals with the instructions given on
# an invoice page. Part of invoice_text and property
# information. Used when editing instructions
#
####
#
class Guide < ApplicationRecord
  MAX_CHAR = 100
  MAX_PROX = 25
  belongs_to :invoice_text
  validates :instruction, presence: true,
                          length: { maximum: MAX_CHAR }
  validates :fillin, presence: true,
                     length: { maximum: MAX_CHAR }
  validates :sample, presence: true,
                     length: { maximum: MAX_PROX }
end
