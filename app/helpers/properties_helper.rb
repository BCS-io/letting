module PropertiesHelper
  def heading entity
    entity.company? ? 'Company Name ' : 'Name'
  end

  def hide_or_destroy record
    record.new_record? ? 'js-hide-link' : 'js-destroy-link'
  end

  def hide_new_record_unless_first record, index
    record.new_record? && index > 0 ? 'js-revealable' : ''
  end

  def hide_if_first_record index
    'js-revealable' if index == 0
  end

  def destroyable record, index
    record.persisted? && index > 0 ? 'destroyable' : ''
  end

  def hide_field_on_start_by_entity_type record
    record.company? ? 'js-toggle-on-start' : ''
  end
end
