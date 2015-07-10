require 'mysql'
require_relative '../config/database.rb'

namespace :create_table do
  desc "Create users table"
  task :users do
    Database.connect.query("CREATE TABLE IF NOT EXISTS users(id integer primary key auto_increment,age integer,name varchar(50),last_name varchar(50))")
  end

  desc "Create posts table"
  task :posts do
    Database.connect.query("CREATE TABLE IF NOT EXISTS posts(id integer primary key auto_increment,name varchar(50),text varchar(255))")
  end
end
