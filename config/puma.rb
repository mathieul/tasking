rails_env = ENV['RAILS_ENV'] || 'development'

threads 4,4

bind  "unix:///home/deploy/apps/tasking/shared/tmp/puma/tasking-puma.sock"
pidfile "/home/deploy/apps/tasking/current/tmp/puma/pid"
state_path "/home/deploy/apps/tasking/current/tmp/puma/state"

activate_control_app
