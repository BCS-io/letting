require 'rails_helper'

RSpec.describe InvoiceText, type: :model do
  describe 'validations' do
    it('returns valid') { expect(invoice_text_new).to be_valid }
    it('description') { expect(invoice_text_new description: '').not_to be_valid }
    it('needs name') { expect(invoice_text_new invoice_name: '').not_to be_valid }
    it('requires a phone') { expect(invoice_text_new phone: '').not_to be_valid }
    it('requires vat number') { expect(invoice_text_new vat: '').not_to be_valid }
    it('requires heading') { expect(invoice_text_new heading1: '').not_to be_valid }
  end
end
