require 'rails_helper'

RSpec.describe InvoicesMaker, type: :model do
  describe 'range' do
    it 'creates a run of invoices' do
      account_create property: property_new(human_ref: 8)
      invoicing = invoicing_new property_range: '1-10', runs: []
      invoice_text_create id: 1

      first = InvoicesMaker.new invoicing: invoicing
      expect(first.invoices.size).to eq 1
    end

    it 'does not create run if no accounts in range' do
      account_create property: property_new(human_ref: 11)
      invoicing = invoicing_new property_range: '1-10', runs: []
      invoice_text_create id: 1

      first = InvoicesMaker.new invoicing: invoicing
      expect(first.invoices.size).to eq 0
    end
  end

  describe 'invoice_date' do
    it 'defaults to today' do
      account_create property: property_new(human_ref: 8)
      invoicing = invoicing_new property_range: '1-10', runs: []
      invoice_text_create id: 1

      first = InvoicesMaker.new invoicing: invoicing
      expect(first.invoices.first.invoice_date).to eq Time.zone.today
    end

    it 'can be set' do
      account_create property: property_new(human_ref: 8)
      invoicing = invoicing_new property_range: '1-10', runs: []
      invoice_text_create id: 1

      first = InvoicesMaker.new invoicing: invoicing, invoice_date: '2000/01/01'
      expect(first.invoices.first.invoice_date).to eq Date.new(2000, 1, 1)
    end
  end

  describe 'comments' do
    it 'sets comments' do
      account_create property: property_new(human_ref: 8)
      invoicing = invoicing_new property_range: '1-10', runs: []
      invoice_text_create id: 1

      first = InvoicesMaker.new invoicing: invoicing, comments: ['a comment']
      expect(first.invoices.first.comments.size).to eq 1
      expect(first.invoices.first.comments.first.clarify).to eq 'a comment'
    end

    it 'if comments unset it leaves them blank' do
      account_create property: property_new(human_ref: 8)
      invoicing = invoicing_new property_range: '1-10', runs: []
      invoice_text_create id: 1

      first = InvoicesMaker.new invoicing: invoicing
      expect(first.invoices.first.comments.size).to eq 0
    end
  end
end
