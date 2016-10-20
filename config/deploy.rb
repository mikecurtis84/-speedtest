# Change these
# server 'server', port: 7171, roles: [:web, :app, :db], primary: true

set :repo_url,        'https://github.com/mikecurtis84/-speedtest.git'
set :application,     'speedtest'
set :user,            'speedtester'
set :puma_threads,    [4, 16]
set :puma_workers,    0


# set :application, 'speedtest'
# set :repo_url, 'https://github.com/mikecurtis84/-speedtest.git'
# set :rails_env, 'production'


# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false  # Change to true if using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma




# # config valid only for current version of Capistrano
# lock '3.6.1'

# set :application, 'speedtest'
# set :repo_url, 'https://github.com/mikecurtis84/-speedtest.git'
# set :rails_env, 'production'

# # Default branch is :master
# # ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# # Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/home/deploy/speedtest'

# # Default value for :scm is :git
# # set :scm, :git

# # Default value for :format is :airbrussh.
# # set :format, :airbrussh

# # You can configure the Airbrussh format using :format_options.
# # These are the defaults.
# # set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# # Default value for :pty is false
#  set :pty, true
#  set :use_sudo,false

# # Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/puma.rb')

# # Default value for linked_dirs is []
# # append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')


# # Default value for default_env is {}
# # set :default_env, { path: "/opt/ruby/bin:$PATH" }

# # Default value for keep_releases is 5
# # set :keep_releases, 5

# # Defaults to :db role
# set :migration_role, :db

# # Defaults to the primary :db server
# set :migration_servers, -> { primary(fetch(:migration_role)) }

# # Defaults to false
# # Skip migration if files in db/migrate were not modified
# set :conditionally_migrate, true

# # Defaults to [:web]
# set :assets_roles, [:web, :app]

# # Defaults to 'assets'
# # This should match config.assets.prefix in your rails config/application.rb
# #set :assets_prefix, 'prepackaged-assets'

# # If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
# set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}

# # Defaults to nil (no asset cleanup is performed)
# # If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# # set this to the number of versions to keep
# set :keep_assets, 2

# # Puma:
# set :puma_conf, "#{shared_path}/config/puma.rb"
 
# namespace :deploy do
#   before 'check:linked_files', 'puma:config'
#   before 'check:linked_files', 'puma:nginx_config'
#   after 'puma:smart_restart', 'nginx:restart'
# end