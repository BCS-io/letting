####
# RevealHelper
#
# Helper to wrap logic for adding and removing collection elements through
# JQuery - reveal collection elements that are hidden on the form.
# Interacts with reveal.js and forms (charges, entities, cycle)
#
# Introduction
# js-group-toggle - the js acts within the box.
# js-enclosed-toggle - the collection element acts within js-group-toggle box.
#
# When you 'add (make visible)' an element we find the closest js-group-toggle
# from the add button and the reveal the first hidden element.
#
# When you 'hide' an element we find the closest js-enclosed box
# hide it, clear it - by adding the js-clear class to the element.
#
# When you 'delete' an element we find the closest js-enclosed box
# hide it, and flag to delete and disable the element
#   - stopping resuse is by adding the js-clear class to the element.
#
####
#
module RevealHelper
  # hide_empty_records_after_first
  #
  # First empty row is visible - subsequent empty rows are hidden.
  #  - css class .js-revealable is an alias for hidden
  #
  # All other, full, rows are initialised as visible
  #
  def hide_empty_records_after_first(record:, index:)
    return '' unless record.empty?

    index.positive? ? 'js-revealable' : ''
  end

  # first_record?(index:)
  # sometimes we want to do something special for the first row.
  # args
  # index - the row's index
  #
  def first_record?(index:)
    return false if index.positive?

    true
  end

  # hide_or_destroy
  #
  # if we are deleting a record do we hide it or do we destroy it?
  # - new records are in memory only and can be cleared and hidden
  #   and then added and reused all within js
  #   - this has no further effect
  # - Persisted Records are flagged to be deleted.
  # args
  # record - record to be hidden or destroyed
  #
  # Functionality all handled by js - currently reveal.js
  #
  def hide_or_destroy(record:)
    record.new_record? ? 'js-hide-link' : 'js-destroy-link'
  end
end
