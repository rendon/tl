require 'active_record'
require_relative 'application'
ActiveRecord::Base .establish_connection(adapter: 'sqlite3',
                                         database: Application.db_file)
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate(Application.migrate_dir)
class Translation < ActiveRecord::Base
end
