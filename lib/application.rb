require_relative 'config'
# Provides configuration values for the application.
class Application
  def self.app_dir
    @app_dir ||= CONFIG[CONFIG[:env]][:app_dir]
  end

  def self.db_file
    @db_file ||= CONFIG[CONFIG[:env]][:db_file]
  end

  def self.strings_dir
    @strings_dir ||= CONFIG[CONFIG[:env]][:strings_dir]
  end

  def self.player
    @player ||= CONFIG[CONFIG[:env]][:player]
  end

  def self.migrate_dir
    @migrate_dir ||= CONFIG[CONFIG[:env]][:migrate_dir]
  end
end
