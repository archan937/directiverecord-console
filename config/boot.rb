require "bundler"
Bundler.require

config = YAML.load_file(File.expand_path("../database.yml", __FILE__))
logger = Logger.new(File.expand_path("../../log/console.log", __FILE__))

ActiveRecord::Base.establish_connection config
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.default_timezone = :local
ActiveRecord::Base.logger = logger

Dir[File.expand_path("../../app/**/*.rb", __FILE__)].each{|file| require file}
