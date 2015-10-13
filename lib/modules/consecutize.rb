####
#
# Consecutize
#
# Turns a list of numbers into comma separated if discontinuous or hyphenated
# if continuous.
#
# Example
#
# [1, 2, 3, 5, 7, 8, 9, 20, 21, 23, 29]
# => [[1, 2, 3], [5], [7, 8, 9], [20, 21], [23], [29]]
#
####
#
class Consecutize
  attr_reader :elements
  def initialize elements: []
    @elements = elements
  end

  def add element
    @elements << element
  end

  def merge consecutize
    @elements += consecutize.elements
  end

  def to_s
    make
    output = ''
    @classified_numbers.each do |element|
      output += ', ' if output.size.nonzero?
      output += build element
    end
    output
  end

  private

  def make
    actual = elements.first
    @classified_numbers = elements.slice_before do |e|
      expected = actual.next
      actual = e
      expected != actual
    end.to_a
    self
  end

  def build element
    if continuous_numbers?(numbers: element)
      output_continuous_numbers(numbers: element)
    else
      output_discontinous_number(number: element)
    end
  end

  def continuous_numbers?(numbers:)
    numbers.size > 1
  end

  def output_continuous_numbers(numbers:)
    "#{numbers.first} - #{numbers.last}"
  end

  def output_discontinous_number(number:)
    "#{number.first}"
  end

  def make_consecutive_arrays
    elements.zip elements.drop(1).push(elements[-1] + 2)
  end
end
