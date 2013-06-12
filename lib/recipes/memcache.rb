require 'capistrano-zen/base'

configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do
  namespace :memcache do
    desc "Install the latest relase of Memcache"
    task :install, roles: :app do
      run "#{sudo} apt-get -y install memcached"
    end
  end
end
