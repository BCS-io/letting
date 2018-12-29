# rubocop: disable Metrics/ParameterLists

def user_create id: nil,
                nickname: 'user',
                email: 'user@example.com',
                password: 'password',
                password_confirmation: 'password',
                role: 'user'
  user = User.new id: id,
                  nickname: nickname,
                  email: email,
                  password: password,
                  password_confirmation: password_confirmation,
                  role: role
  user.save!
  user
end
