require 'resque'
require 'resque_scheduler'
require 'resque_scheduler/server'
require 'resque/scheduler'

Resque::Server.use(Rack::Auth::Basic) do |user, password|
    user == "resque" and password == "GFctnLKn6dJNU8PF"
end

Dir["#{Rails.root}/lib/jobs/*.rb"].each { |file| require file }
Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
