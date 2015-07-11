require_relative '../initializer.rb'

namespace :load do
  desc "Load fixtures to database"
  task :fixtures do
    DataLoader.execute
  end
end
