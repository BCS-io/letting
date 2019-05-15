# Define Cron jobs
#
# Testing if cron job running as expected
#  - check in  letting/shared/log/cron.log it is running
#
# In development system remove deleted_at
# update credits set deleted_at = null;
# update debits set deleted_at = null;
# cap <envioronment> db:push
# Wait till after cron has run and page down to see if deleted_at has any rows
# filled.
#
# rubocop: disable Metrics/LineLength
#
set :output, "#{path}/log/cron.log"
env :PATH, ENV['PATH']

case @environment

when 'development'

  job_type :rbenv_rake, %{export PATH=~/.rbenv/shims:~/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                        cd :path && :environment_variable=:environment bundle exec rake :task --silent :output }

  every 1.minute do
    rbenv_rake 'hide_monotonous_account_details'
  end

else

  job_type :rake, %( cd :path && :environment_variable=:environment bundle exec rake :task --silent :output )
  every 1.day, at: '4:30 am' do
    rake 'hide_monotonous_account_details'
  end
end
