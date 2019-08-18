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
class Client < ApplicationRecord
  include Contact
  include StringUtils
  has_many :properties, dependent: :destroy
  before_validation :clear_up_form

  validates :human_ref, numericality: { only_integer: true, greater_than: 0 }
  validates :human_ref, uniqueness: true
  validates :entities, presence: true

  delegate :full_names, to: :entities

  def address_text
    return '' if address.nil?

    address.text
  end

  def prepare_for_form
    prepare_contact
  end

  delegate :clear_up_form, to: :entities

  def self.match_by_human_ref human_ref
    return none unless num? human_ref

    where human_ref: human_ref
  end

  def self.by_human_ref
    order(:human_ref).includes(:address)
  end

  def to_s
    address.name_and_address name: full_names
  end

  include Searchable

  mapping dynamic: 'false' do
    indexes :human_ref, type: :integer, index: false
    indexes :full_names, type: :text, copy_to: :text_record
    indexes :address_text, type: :text, copy_to: :text_record
    indexes :created_at, index: false
    indexes :updated_at, index: false
    indexes :text_record, type: :text, analyzer: :nGram_analyzer,
                          search_analyzer: :whitespace_analyzer
  end

  def as_indexed_json(_options = {})
    as_json(
      methods: %i[full_names address_text],
      except: %i[id created_at updated_at]
    )
  end
end
