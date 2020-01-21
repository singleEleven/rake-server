require 'yaml'

require './lib/router'

# Creating database context
db_config_file = File.join(File.dirname(__FILE__), 'app', 'database.yml')
if File.exist?(db_config_file)
  config = YAML.load(File.read(db_config_file))
  DB = Sequel.connect(config)
  Sequel.extension :migration
end

# Connecting all our framework's classes
Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|file| require file }

# Connecting all our framework's files
Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each {|file| require file }

if DB
  Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), 'app', 'db', 'migrations'))
end

ROUTES = YAML.load(File.read(File.join(File.dirname(__FILE__), "app", "routes.yml")))


class App
  attr_reader :router

  def self.root
    File.dirname(__FILE__)
  end

  def initialize
    @router = Router.new(ROUTES)
  end

  def call(env)
    results = router.resolve(env)
    [results.status, results.headers, results.content]
  end
end