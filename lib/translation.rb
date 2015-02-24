require 'active_record'
require_relative 'application'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                        database: "#{Application.app_dir}/db/translations.db")

ActiveRecord::Migrator.migrate('db/migrate')
class Translation < ActiveRecord::Base
end
