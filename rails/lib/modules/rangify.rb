####
#
# Rangify
#
# Class for coping with range string representation
#
# Rangify is used for the rake tasks to handle string representations of ranges
# Used to turn strings with dashes (-) into integer arrays.
#
####
#
class Rangify
  attr_reader :range_as_str

  def self.from_str range_as_str
    new(range_as_str)
  end

  def initialize range_as_str
    @range_as_str = range_as_str
    @range_as_str = "#{range_as_str}-#{range_as_str}" unless string_is_range?
  end

  def string_is_range?
    range_as_str.include? '-'
  end

  def to_i
    Range.new(*range_as_str.split('-').map(&:to_i))
  end

  def to_s
    range_as_str
  end
end
