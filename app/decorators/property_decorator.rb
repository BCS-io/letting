require_relative '../../lib/modules/method_missing'
####
#
# PropertyDecorator
#
# Adds behaviour to the property object
#
# Used when the property has need for behaviour outside of the core
# of the model. Specifically for display information.
#
#
####
#
class PropertyDecorator
  include MethodMissing

  def property
    @source
  end

  def initialize property
    @source = property
  end

  def client_ref
    client&.human_ref
  end

  def agent_name
    if property.agent.authorized?
      property.agent.full_names
    else
      'None'
    end
  end

  def agent_address_lines
    if property.agent.authorized?
      property.agent.address.text
    else
      '-'
    end
  end

  # The edited property is visually known as an Account
  #
  #
  def class
    Account
  end
end
