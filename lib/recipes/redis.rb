require 'capistrano-zen/base'

configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do
  namespace :redis do
    desc "Install the latest relase of Redis"
    task :install, roles: :app do
      run "#{sudo} add-apt-repository -y ppa:rwky/redis"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install redis-server"
    end
  end
end
