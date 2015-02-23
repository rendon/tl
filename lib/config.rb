CONFIG = {
  :env => :development,
  development: {
    app_dir: File.expand_path(File.dirname(__FILE__)) + '/../app_dir',
    cache_results: false
  },
  test: {
    app_dir: File.expand_path(File.dirname(__FILE__)) + '/../app_dir',
    cache_results: false
  },
  production: {
    app_dir: Dir.home + '/.tli',
    cache_results: true
  }
}

