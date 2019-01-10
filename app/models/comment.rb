#
# Comment
# Invoices can have a number (defined as between 0-2) of comments associated.
# These are the comments ...
#
class Comment < ApplicationRecord
  include CommentDefaults
  belongs_to :invoice

  validates :clarify, length: { maximum: MAX_CLARIFY },
                      allow_blank: false
end
