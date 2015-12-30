# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'infrno'
set :repo_url, 'git@github.com:d00n/crit.git'
set :passenger_restart_with_touch, true

set :branch, $1 if `git branch` =~ /\* (\S+)\s/m
# set :branch, ENV['BRANCH'] || 'develop'

set :rvm_type, :auto
set :rvm_ruby_version, '2.0.0-p643@strip01'
set :rvm_path, '/usr/local/rvm'

task :production do
  role :web, "deploy@54.69.82.151"
  role :app, "deploy@54.69.82.151"
  role :db, "deploy@54.69.82.151", :primary => true
  set :robots_file, "robots.txt.production"
end


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5



namespace :deploy do

  #after :restart, :clear_cache do
  task :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
         execute :rake, 'assets:clobber'
      end
    end
  end
end

desc "Check that we can access everything"
task :check_write_permissions do
  on roles(:all) do |host|
    if test("[ -w #{fetch(:deploy_to)} ]")
      info "#{fetch(:deploy_to)} is writable on #{host}"
    else
      error "#{fetch(:deploy_to)} is not writable on #{host}"
    end
  end
end

#task :update_rvm_key do
#  on roles :all do
#    execute :gpg2, "--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3"
#  end
#end
#before "rvm1:install:rvm", "update_rvm_key"
