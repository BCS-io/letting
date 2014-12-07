####
#
# Address
#
# Why does the class exist?
#
# Represents an address of either a property or a person in the system.
#
# How does it fit in the larger system?
#
# Property, Agent and Clients all require and has_one
# address.
#
####
#
class Address < ActiveRecord::Base
  include AddressDefaults
  belongs_to :addressable, polymorphic: true
  validates :county, :road, presence: true
  validates :flat_no, :road_no,
            length: { maximum: MAX_NUMBER },
            allow_blank: true
  validates :house_name, length: { maximum: MAX_STRING }, allow_blank: true
  validates :road,       length: { maximum: MAX_STRING }
  validates :district, :nation, :town,
            length: { minimum: MIN_STRING, maximum: MAX_STRING },
            allow_blank: true
  validates :county,   length: { minimum: MIN_STRING, maximum: MAX_STRING }
  validates :postcode,
            length: { minimum: MIN_POSTCODE, maximum: MAX_POSTCODE },
            allow_blank: true

  # Appending the name to the address and only setting join char once.
  # join - the character between  each line
  #
  def name_and_address name:, join: "\n"
    name + join + text(join: join)
  end

  # All the address text without any empty lines of the address
  # join - the character between each line
  #
  def text join: "\n"
    address_lines.join "#{join}"
  end

  # The most meaningful lines of the address
  # join - the character between each line
  #
  def abridged_text join: "\n"
    [first_line, town.present? ? town : county].join "#{join}"
  end

  # The first line filled in - houses don't require the flat information
  #
  def first_line
    address_lines.first
  end

  def clear_up_form
    mark_for_destruction
  end

  private

  def flat_line
    flat_house_line.present? ? "Flat #{flat_house_line}" : nil
  end

  def flat_house_line
    "#{flat_no} #{house_name}".strip
  end

  def road_line
    "#{road_no} #{road}".strip
  end

  def address_lines
    [
      flat_line,
      road_line,
      district,
      town,
      county,
      postcode,
      nation
    ].compact.delete_if(&:empty?)
  end
end
