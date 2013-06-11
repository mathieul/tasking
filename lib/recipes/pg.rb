require 'capistrano-zen/base'
require 'yaml'

configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do

  _cset(:pg_config_path) { File.expand_path("../../../config", __FILE__) }
  _cset(:pg_backup_path) { File.expand_path("../../../tmp", __FILE__) }

  DB_FILE_PATH = "#{pg_config_path}/database.yml"
  DBCONFIG = YAML.load_file(DB_FILE_PATH)

  _cset(:psql_host) { DBCONFIG['production']['host'] }
  _cset(:psql_user) { DBCONFIG['production']['username'] }
  _cset(:psql_password) { DBCONFIG['production']['password'] }
  _cset(:psql_database) { DBCONFIG['production']['database'] }

  namespace :pg do
    desc "Install the latest stable release of psql."
    task :install, roles: :db, only: {primary: true} do
      run "#{sudo} add-apt-repository -y 'deb http://ppa.launchpad.net/pitti/postgresql/ubuntu quantal main'"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install postgresql-9.3 libpq-dev"
    end

    desc "Create a database for this application."
    task :init, roles: :db, only: { primary: true } do
      # reset the database and role
      run %Q{#{sudo} -u postgres psql -c "CREATE USER #{psql_user} WITH PASSWORD '#{psql_password}';"}
      run %Q{#{sudo} -u postgres psql -c "CREATE DATABASE #{psql_database} OWNER #{psql_user};"}
    end

    desc "Reset the database and role for this application."
    task :reset, roles: :db, only: { primary: true } do
      # drop the database and role
      run %Q{#{sudo} -u postgres psql -c "DROP DATABASE #{psql_database};"}
      run %Q{#{sudo} -u postgres psql -c "DROP ROLE #{psql_user};"}
    end

    desc "Generate the database.yml configuration file."
    task :setup, roles: :app do
      run "mkdir -p #{shared_path}/config"
      template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
      # init backup directory
      run "#{sudo} mkdir -p #{pg_backup_path}"
      run "#{sudo} chown :#{group} #{pg_backup_path}"
      run "#{sudo} chmod g+w #{pg_backup_path}"
    end

    desc "Symlink the database.yml file into latest release"
    task :symlink, roles: :app do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end

    desc "Dump the application's database to backup path."
    task :dump, roles: :db, only: { primary: true } do
      # ignore migrations / exclude ownership / clean restore
      run "pg_dump #{psql_database} -T '*migrations' -O -c -U #{psql_user} -h #{psql_host} | gzip > #{pg_backup_path}/#{application}-#{release_name}.sql.gz" do |channel, stream, data|
        puts data if data.length >= 3
        channel.send_data("#{psql_password}\n") if data.include? 'Password'
      end
    end

    desc "Restore the application's database from dump files."
    task :restore, roles: :db, only: { primary: true } do
      backups = capture("ls -x #{pg_backup_path}").split.sort
      default_backup = backups.last
      puts "Available backups: "
      puts backups
      backup = Capistrano::CLI.ui.ask "Which backup would you like to restore? [#{default_backup}] "
      backup = backups.last if backup.empty?
      run "gunzip -c #{pg_backup_path}/#{backup} | psql -d #{psql_database} -U #{psql_user} -h #{psql_host}" do |channel, stream, data|
        puts data if data.length >= 3
        channel.send_data("#{psql_password}\n") if data.include? 'Password'
      end
    end
  end
end
