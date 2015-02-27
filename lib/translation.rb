require 'active_record'
require_relative 'application'
ActiveRecord::Base .establish_connection(adapter: 'sqlite3',
                                         database: Application.db_file)

ActiveRecord::Migrator.migrate('db/migrate')
class Translation < ActiveRecord::Base
end
