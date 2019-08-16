require 'rails_helper'

RSpec.describe 'UserFactory' do
  describe 'user_create' do
    it('is created') { expect(user_create).to be_valid }
    it('has nickname') { expect(user_create.nickname).to eq 'user' }

    describe 'override' do
      it 'alters nickname' do
        expect(user_create(nickname: 'zed').nickname).to eq 'zed'
      end
    end
  end
end
