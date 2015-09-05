namespace :elasticsearch do
  desc 'Runs rake elasticsearch:sync if migrations are set'
  task :sync do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'elasticsearch:sync'
        end
      end
    end
  end
end
