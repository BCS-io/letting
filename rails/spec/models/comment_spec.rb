require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validates' do
    it 'requires clarify' do
      expect(Comment.new(clarify: nil, invoice: invoice_new)).to_not be_valid
    end

    it 'allows up to max chars' do
      expect(Comment.new(clarify: 'X' * CommentDefaults::MAX_CLARIFY,
                         invoice: invoice_new))
        .to be_valid
    end

    it 'rejects above max chars' do
      expect(Comment.new(clarify: 'X' * (CommentDefaults::MAX_CLARIFY + 1),
                         invoice: invoice_new))
        .to_not be_valid
    end
  end
end
