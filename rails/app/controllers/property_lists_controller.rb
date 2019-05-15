####
#
# PropertyListsController
#
# Why does this class exist?
#
# To list out al properties/accounts in the system
#
# How does this fit into the larger system?
#
# Properties are at the heart of the application &
# the client/user needs this information
#
####
#
class PropertyListsController < ApplicationController
  layout 'print_layout'

  def index
    @records = Property.includes(:entities)
                       .by_human_ref.load
  end
end
