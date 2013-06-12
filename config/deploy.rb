#
# Read:
# - http://ariejan.net/2011/09/14/lighting-fast-zero-downtime-deployments-with-git-capistrano-nginx-and-unicorn
# - http://www.modrails.com/documentation/Users%20guide%20Nginx.html
#

require "erb"
require "bundler/capistrano"
require "puma/capistrano"
require "capistrano-zen/nginx"
require File.expand_path("../../lib/recipes/pg", __FILE__)
require File.expand_path("../../lib/recipes/nodejs", __FILE__)
require File.expand_path("../../lib/recipes/redis", __FILE__)

set :application, "tasking"
set :domain, "cloudigisafe.com"
set :repository,  "git@github.com:mathieul/tasking.git"
set :scm, :git
set :branch, "origin/master"
set :deploy_via, :remote_cache
set :migrate_target,  :current
set :ssh_options, forward_agent: true
set :default_run_options, pty: true, shell: "bash"
set :rails_env, "production"
set :deploy_to, "/home/deploy/apps/tasking"
set :shared_children, ["system", "log", "pids", "git", "sockets"]

set :user, "deploy"
set :group, "deploy"

set :nginx_site_conf, File.expand_path("../nginx-site.conf.erb", __FILE__)

role :web, domain
role :app, domain
role :db,  domain, :primary => true

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

default_environment["RAILS_ENV"] = rails_env

namespace :deploy do
  desc "Deploy your application"
  task :default do
    update
    restart
  end

  desc "Setup your git-based deployment app"
  task :setup, except: {no_release: true} do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "mkdir -p #{dirs.join(" ")} && chmod g+w #{dirs.join(" ")}"
    run "git clone #{repository} #{current_path} || true"
    run "gem install bundler && rbenv rehash"
  end

  desc "Cleanup application files"
  task :cleanup_all, except: {no_release: true} do
    run "rm -rf #{deploy_to}"
    puts "removed directory #{deploy_to}"
  end

  task :cold do
    update
    migrate
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, except: {no_release: true} do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    transaction do
      update_code
    end
    migrate
    restart
  end

  task :finalize_update, except: {no_release: true} do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids #{latest_release}/tmp/git &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -s #{shared_path}/system #{latest_release}/public/system &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids &&
      ln -s #{shared_path}/git #{latest_release}/tmp/git
    CMD
  end

  desc "Rehash rbenv"
  task :rbenv_rehash do
    run "cd #{current_path}; rbenv rehash"
  end

  desc "Populates the Production Database"
  task :db_seed do
    puts "\n\n=== Populating the Production Database! ===\n\n"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake db:seed"
  end

  desc "Setup nginx for this application"
  task :setup_nginx, roles: :web do
    template = File.read(nginx_site_conf)
    conf = ERB.new(template).result(binding)
    available_file = "/etc/nginx/sites-available/#{application}.#{domain}"
    enabled_file = "/etc/nginx/sites-enabled/#{application}.#{domain}"
    put conf, available_file
    run "rm -f #{enabled_file} && ln -fs #{available_file} #{enabled_file}"
    run "#{sudo} /etc/init.d/nginx reload"
  end

  desc "Cleanup nginx config for this application"
  task :cleanup_nginx, roles: :web do
    available_file = "/etc/nginx/sites-available/#{application}.#{domain}"
    enabled_file = "/etc/nginx/sites-enabled/#{application}.#{domain}"
    run "rm -f #{enabled_file} #{available_file}"
    run "#{sudo} /etc/init.d/nginx reload"
  end

  desc "Start Resque workers"
  task :start_resque do
    run "cd #{current_path}; bundle exec god start -c config/resque.god"
  end

  desc "Stop Resque workers"
  task :stop_resque do
    run "cd #{current_path}; bundle exec god terminate"
  end

  desc "Hot-reload God configuration for the Resque workers"
  task :reload_resque do
    run "cd #{current_path}; bundle exec god stop resque"
    run "cd #{current_path}; bundle exec god load config/resque.god"
    run "cd #{current_path}; bundle exec god start resque"
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, except: {no_release: true} do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, except: {no_release: true} do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end

after "bundle:install", "deploy:rbenv_rehash"
after "deploy:setup", "bundle:install"
# after "deploy:finalize_update", "deploy:rbenv_rehash"

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end
