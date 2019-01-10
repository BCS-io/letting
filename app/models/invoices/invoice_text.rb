####
#
# InvoiceText
#
# Invoice Text holds the general information needed for an
# invoice printout, excluding individual account
# and property information. Allows editing of
# this information,
# Front page includes the agent F&L Adams details,
# and text needed on 1st page of invoice
# Back page holds details of 'Notice of Rent Due,'
# only used for Ground Rent.
#
# Invoice Text Constants
#
# Constants relating to Invoice text files 1 & 2
# These hold the texts used on both pages of the invoices
# Page 1 is the front page which all invoices have.
# Page 2 is the back page for Ground Rents only.
# This back page contains legal advice for the occupier
#
####
#
class InvoiceText < ApplicationRecord
  validates :invoice_name, :description, :heading1, :phone, :vat,
            presence: true
  has_one :address, class_name: 'Address',
                    dependent: :destroy,
                    as: :addressable
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :guides, dependent: :destroy
  accepts_nested_attributes_for :guides, allow_destroy: true
  has_many :invoices, through: :letters
  has_many :letters, dependent: :destroy

  def page1?
    self == InvoiceText.first
  end
end
