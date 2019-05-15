####
#
# ErrorsController
#
####
#
class ErrorsController < ApplicationController
  def not_found
    render status: :not_found, formats: [:html]
  end

  def server_error
    render status: :internal_server_error, formats: [:html]
  end
end
