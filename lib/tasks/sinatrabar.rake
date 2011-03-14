namespace :sinatrabar do
  desc "Sets up configuration and database"
  task :install do
    # Install task (sets up config/pianobar) and then runs db:migrate
  end
  desc "Starts the application"
  task :start do
    # Starts application
  end
end

namespace :db do
  desc "Set up initial database"
  task :setup do
    # migration task
  end
  desc "Drops application database"
  task :drop do
    # drop task
  end
end
