Gem::Specification.new do |s|
  s.name          = 'tli'
  s.version       = '0.0.5'
  s.date          = '2015-02-19'
  s.summary       = 'TransLate It! A command line tool to translate text from \
                     (and to) almost any language.'
  s.description   = 'With tli you can translate text and find definitions using\
                     services like Google Translate, Yandex, Cambridge \
                     dictionaries, etc. All in one.'
  s.authors       = ['Rafael Rendón Pablo']
  s.email         = 'rafaelrendonpablo@gmail.com'
  s.files         = `git ls-files -- lib/* assets/* db/*`.split("\n")
  
  s.add_dependency 'rest-client', '1.7.2'
  s.add_dependency 'activerecord', '4.2.0'
  s.add_dependency 'sqlite3', '1.3.10'

  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/rendon/tli'
  s.license       = 'GPL-3.0'
end
