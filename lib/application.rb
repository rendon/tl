require_relative 'config'
class Application
  def self.app_dir
    @app_dir ||= CONFIG[CONFIG[:env]][:app_dir]
  end

  def self.app_dir=(value)
    @app_dir = value
  end

  def self.cache_results
    @cache_results ||= CONFIG[CONFIG[:env]][:cache_results]
  end

  def self.cache_results=(value)
    @cache_results = value
  end
end

