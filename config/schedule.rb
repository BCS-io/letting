# file to define cron jobs
#
# rubocop: disable Metrics/LineLength
#
set :output, "#{path}/log/cron.log"
env :PATH, ENV['PATH']

case @environment

when 'development'

  job_type :rbenv_rake, %{export PATH=~/.rbenv/shims:~/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                        cd :path && :environment_variable=:environment bundle exec rake :task --silent :output }

  every 1.minutes do
    rbenv_rake 'hide_monotonous_account_details'
  end

else

  job_type :rake, %{ cd :path && :environment_variable=:environment bundle exec rake :task --silent :output }
  every 1.minutes, at: '4:30 am' do
    rake 'hide_monotonous_account_details'
  end
end
