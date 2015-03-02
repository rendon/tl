app_dir = '/tmp/.tli'
working_directory = File.expand_path(File.dirname(__FILE__))
CONFIG = {
  env: :development,
  development: {
    app_dir: app_dir,
    strings_dir: working_directory + '/../assets/strings',
    db_file: app_dir + '/db/translations.db',
    migrate_dir: working_directory + '/../db/migrate',
    cache_results: false,
    player: 'touch'
  },
  test: {
    app_dir: app_dir,
    strings_dir: working_directory + '/../assets/strings',
    db_file: app_dir + '/db/translations.db',
    migrate_dir: working_directory + '/../db/migrate',
    cache_results: false,
    player: 'touch'
  },
  production: {
    app_dir: Dir.home + '/.tli',
    strings_dir: working_directory + '/../assets/strings',
    db_file: Dir.home + '/.tli/db/translations.db',
    migrate_dir: working_directory + '/../db/migrate',
    cache_results: true,
    player: 'mplayer'
  }
}
