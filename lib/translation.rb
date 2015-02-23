require 'active_record'
require_relative 'application'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                        database: "#{Application.app_dir}/db/translations.db")

ActiveRecord::Migrator.migrate('db/migrate')
class Translation < ActiveRecord::Base
  def self.find_google_translation(text, source, target)
    Translation.where(text: text, source: source, target: target, service: 'google').first
  end
end
