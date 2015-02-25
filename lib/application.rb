require_relative 'config'
class Application
  def self.app_dir
    @app_dir ||= CONFIG[CONFIG[:env]][:app_dir]
  end
end

