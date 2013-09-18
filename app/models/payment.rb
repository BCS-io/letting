class Payment < ActiveRecord::Base
  belongs_to :account
  belongs_to :debt

  validates :debt_id, :on_date, presence: true
  validates :amount, :format => { :with => /\A\d+??(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal_to => 0}

  scope :latest_payments, ->(limit) { order(created_at: :desc).limit(limit) }

end
