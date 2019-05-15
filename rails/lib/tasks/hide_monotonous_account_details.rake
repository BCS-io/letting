desc 'cron task for hiding old account transactions that are balancing'
task hide_monotonous_account_details: :environment do
  Account.hide_monotonous_account_details
end
