# ActAsFakeDeletable
#
# Pretend to delete data - instead flag row up and
# add scope to filter rows out.
#
#
module ActAsFakeDeletable
  extend ActiveSupport::Concern
  included do
    # override the model actions
    def fake_delete
      update_columns(deleted_at: DateTime.current)
    end

    scope :deleted, -> { where.not(deleted_at: nil) }
    scope :kept, -> { where(deleted_at: nil) }
  end
end
