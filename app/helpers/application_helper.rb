####
#
# ApplicationHelper
#
# Shared helper methods
#
# rubocop: disable Metrics/MethodLength
#
####
#
module ApplicationHelper
  def format_empty_string_as_dash a_string
    a_string.blank? ? '-'  : a_string
  end

  def noticable_date_range(start_date:, end_date:)
    if (start_date && start_date.year) == (end_date && end_date.year)
      "#{safe_date(date: start_date, format: :month_date)} - "\
      "#{safe_date(date: end_date, format: :month_date)}"
    else
      "#{safe_date(date: start_date, format: :short)} - "\
      "#{safe_date(date: end_date, format: :short)}"
    end
  end

  def safe_date(date:, format:)
    return '' unless date
    "#{I18n.l date, format: format}"
  end

  def view_link model
    if model.new_record?
      link_to fa_icon('file-o lg'),
              '#',
              class: 'plain-button float-right',
              disabled: true, title: 'View file (disabled)'
    else
      link_to fa_icon('file-o lg'),
              model,
              class: 'plain-button float-right',
              title: 'View file'
    end
  end

  def edit_link model
    link_to fa_icon('edit lg'),
            [:edit, model],
            class: 'plain-button float-right',
            title: 'Edit file'
  end
end
