working_directory = File.expand_path(File.dirname(__FILE__))
CONFIG = {
  env: :development,
  development: {
    app_dir: working_directory + '/../app_dir',
    strings_dir: working_directory + '/../assets/strings',
    db_file: working_directory + '/../app_dir/db/translations.db',
    cache_results: false,
    player: 'touch'
  },
  test: {
    app_dir: working_directory + '/../app_dir',
    strings_dir: working_directory + '/../assets/strings',
    db_file: working_directory + '/../app_dir/db/translations.db',
    cache_results: false,
    player: 'touch'
  },
  production: {
    app_dir: Dir.home + '/.tli',
    strings_dir: working_directory + '/../assets/strings',
    db_file: Dir.home + '/.tli/db/translations.db',
    cache_results: true,
    player: 'mplayer'
  }
}
