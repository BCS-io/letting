####
# MethodMissing
#
# Implemented methods required for method missing
# Used as mixin in most of the decorator objects.
#
####
#
module MethodMissing
  def method_missing method_name, *args, &block
    @source.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @source.respond_to?(method_name, include_private) || super
  end
end
