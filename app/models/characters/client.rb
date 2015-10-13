
require_relative '../../../lib/modules/string_utils'

####
#
# Client
#
# Clients
#
# Clients have a number of properties. Clients have an address
# and contact information (address and entity).
#
####
#
class Client < ActiveRecord::Base
  include Contact
  include StringUtils
  has_many :properties, dependent: :destroy
  before_validation :clear_up_form

  validates :human_ref, numericality: { only_integer: true, greater_than: 0 }
  validates :human_ref, uniqueness: true
  validates :entities, presence: true

  delegate :full_names, to: :entities

  def prepare_for_form
    prepare_contact
  end

  delegate :clear_up_form, to: :entities

  def self.find_by_human_ref human_ref
    return nil unless num? human_ref

    find_by human_ref: human_ref
  end

  def self.by_human_ref
    order(:human_ref).includes(:address)
  end

  def to_s
    address.name_and_address name: full_names
  end

  include Searchable
  def as_indexed_json(_options = {})
    as_json(methods: :to_s)
  end
end
