require_relative '../../lib/modules/method_missing'

###
#
# UserDecorator
#
# Adds display logic to the user business object.
#
##
#
class UserDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing

  def user
    @source
  end

  def initialize user
    @source = user
  end
end
