require 'active_record'
require 'sqlite3'
require 'association-reporter'
require 'association-reporter/reporter'

DB_DIR = File.join(AssociationReporter::PROJECT_ROOT, "spec", "db")

def reload
  model_files = File.join(DB_DIR, "models", "*.rb")
  Dir.glob(model_files).each { |f| load f }
end

reload

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(DB_DIR, "example.db")
)
ActiveRecord::Base.connection
