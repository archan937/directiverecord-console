#!/usr/bin/env rake

require "bundler"
Bundler.require

config = YAML.load_file(File.expand_path("../config/database.yml", __FILE__))
host, port, username, password, database = config.values_at *%w(host port username password database)
db = File.expand_path("../db", __FILE__)

namespace :db do
  task :install do
    puts "Installing #{database} ..."

    ActiveRecord::Base.establish_connection config.merge("database" => nil)

    begin
      ActiveRecord::Base.connection.create_database database, {:charset => "utf8", :collation => "utf8_unicode_ci"}
    rescue Exception => e
      raise e unless e.message.include?("database exists")
    end

    `#{
      [
        "mysql",
       ("-h #{host}" unless host.blank?), ("-P #{port}" unless port.blank?),
        "-u #{username || "root"}", ("-p#{password}" unless password.blank?),
        "#{database} < #{db}/database.sql"
      ].compact.join(" ")
    }`

    puts "Done."
  end

  task :dump do
    puts "Dumping database SQL ..."

    `#{
      [
        "mysqldump",
       ("-h #{host}" unless host.blank?), ("-P #{port}" unless port.blank?),
        "-u #{username || "root"}", ("-p#{password}" unless password.blank?),
        "--no-create-db --add-drop-table",
        "#{database} > #{db}/database.sql"
      ].compact.join(" ")
    }`

    puts "Done."
  end
end
