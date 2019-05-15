#
# Wrapper around path pairings of
# controller and action.
#
#
class Referrer
  attr_reader :controller, :action

  def initialize(controller:, action:)
    @controller = controller
    @action = action
  end

  def to_s
    "controller: #{controller}, action: #{action}"
  end
end
