require_relative '../../lib/modules/method_missing'
####
#
# AgentWith
#
# Makes a Agent hold a unique identifier.
#
# Import records for Agents do not have a human_ref that identifies
# them. The identifier, instead, comes from the Property's human_ref.
#
# Identifying a Agent by the human_ref is only needed during the
# import process. To achieve this I associate the human id of the property
# during the import with this service class.
#
####
#
class AgentWithId
  include MethodMissing
  attr_accessor :human_ref

  def initialize agent = Agent.new
    @source = agent
  end
end
