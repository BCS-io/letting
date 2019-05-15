require_relative 'extract'

####
#
# ExtractRef
#
# Removes records, array elements, from an array matching on human_ref.
#
# ExtractRef is part of the staging process - this one is only used
# for testing because of simplicity of matching method
#
####
#
class ExtractRef < Extract
  def match original, patch
    original[:human_ref] == patch[:human_ref]
  end
end
