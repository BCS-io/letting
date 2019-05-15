require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it('is valid') { expect(user_create).to be_valid }

    describe '#email' do
      it 'present' do
        expect { user_create email: nil }
          .to raise_error ActiveRecord::RecordInvalid
      end

      it 'is unique - regardless of case' do
        user_create email: 'user@example.com'
        expect { user_create email: 'user@ExamPle.com' }
          .to raise_error ActiveRecord::RecordInvalid
      end

      it 'requires @' do
        expect { user_create email: 'noat' }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end

    describe 'password' do
      it 'is present' do
        # Bug you can't assign a nil password you can initialize it with
        # empty string
        # stackoverflow.com why-is-password-validate-presence-ignored
        user = User.new password: ''
        expect(user).to_not be_valid
      end

      it 'must equal confirmation' do
        expect do
          user_create password: 'something',
                      password_confirmation: 'orother'
        end
          .to raise_error ActiveRecord::RecordInvalid
      end

      it 'errors with blank confirmation' do
        expect do
          user_create password: 'something',
                      password_confirmation: ''
        end
          .to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
