require 'active_record'

ActiveRecord::Base.configurations['root'] = {:adapter => 'sqlite3', 
                                          :database => ':memory:'}
ActiveRecord::Base.establish_connection(
  ActiveRecord::Base.configurations['root'])
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :delayed_jobs, :force => true do |table|
    table.integer  :priority, :default => 0
    table.integer  :attempts, :default => 0
    table.text     :handler
    table.text     :last_error
    table.datetime :run_at
    table.datetime :locked_at
    table.datetime :failed_at
    table.string   :locked_by
    table.string   :database
    table.timestamps
  end

  add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'

  create_table :stories, :force => true do |table|
    table.string :text
  end
end

# I am an asshole
class ActiveRecord::ConnectionAdapters::SQLite3Adapter
  attr_reader :config
end
