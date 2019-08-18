# Runs first before any other seeding
#
# Seedbank runs everything in seeds directory in alphabetic order
# Seedbank has an option to change dependency but prefer to not put this
# before every other file as it would get repetitive
#

Rake::Task['db:truncate_all'].invoke

admin = User.new(id: 1,
                 nickname: 'admin',
                 email: 'admin@example.com',
                 password: 'password',
                 password_confirmation: 'password',
                 role: 'admin')

user = User.new(id: 2,
                nickname: 'user',
                email: 'user@example.com',
                password: 'password',
                password_confirmation: 'password',
                role: 'user')

User.transaction do
  admin.save!
  user.save!
end
