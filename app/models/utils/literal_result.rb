#
# LiteralResult
#
# Wraps up the search results
#
# rubocop: disable  Metrics/LineLength
#
class LiteralResult
  include Comparable
  attr_reader :action, :controller, :do_not_search, :records

  # initialize
  # args:
  #   controller - controller the action is called on
  #   action: - rest action
  #   records - when more than one record is being returned
  #   do_not_search - do not search
  #
  def initialize(controller:, action:, records: [], do_not_search: false)
    @controller = controller
    @action = action
    @records = records.is_a?(Array) ? records : [records]
    @do_not_search = do_not_search
  end

  # The search not only completed but it also found a result.
  #
  def found?
    return false if do_not_search

    records.present?
  end

  # to_params
  # returns - action, controller, id - enough information to redirect
  #
  def to_params
    params = { controller: controller, action: action }
    single_record? ? params.merge!(id: records.first) : params.merge!(records: records)
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
    [action, controller, records, do_not_search] <=>
      [other.action, other.controller, other.records, other.do_not_search]
  end

  # self.without_a_search
  #
  # The model does not have any literal search query find any specific record.
  #
  def self.without_a_search
    LiteralResult.new action: '', controller: '', records: []
  end

  # self.no_record_found
  #
  # completes LiteralResult - no literal match has been found
  # Same as without_a_search but makes more sense when reading code.
  #
  def self.no_record_found
    LiteralResult.new action: '', controller: '', records: [], do_not_search: true
  end
end
