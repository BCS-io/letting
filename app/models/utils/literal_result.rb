#
# LiteralResult
#
# Wraps up the search results
#
class LiteralResult
  include Comparable
  attr_reader :action, :controller, :records

  # initialize
  # args:
  #   controller - controller the action is called on
  #   action: - rest action
  #   records - when more than one record is being returned
  #   do_not_search - do not search
  #
  def initialize(controller:, action:, records:)
    @controller = controller
    @action = action
    @records = Array(records)
  end

  # The search not only completed but it also found a result.
  #
  def found?
    records.present?
  end

  # to_params
  # returns - action, controller, id - enough information to redirect
  #
  def to_params
    params = { controller: controller, action: action }
    single_record? ? params[:id] = records.first : params[:records] = records
    params
  end

  #
  # Rendering requires we have the view to render
  # returns: the view to render
  #
  def to_render
    "#{controller}/#{action}"
  end

  #
  # If we are displaying a single record
  #
  def single_record?
    records.length == 1
  end

  def <=> other
    return nil unless other.is_a?(self.class)

    [action, controller, records] <=>
      [other.action, other.controller, other.records]
  end

  # self.no_record_found
  #
  # completes LiteralResult - no literal match has been found
  #
  def self.no_record_found
    LiteralResult.new action: '', controller: '', records: []
  end
end
