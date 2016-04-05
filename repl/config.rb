require 'irb/completion'

require_relative '../spec/spec_helper'
require_relative '../spec/factories/model-factories'


ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './repl.db'
)
ActiveRecord::Migration.verbose = false
ModelFactories::CreateTestTables.migrate(:down)
ModelFactories::CreateTestTables.migrate(:up)

ModelFactories.define_all_models

IRB.conf[:HISTORY_FILE] = './.irb-history'
IRB.conf[:SAVE_HISTORY] = 1000
