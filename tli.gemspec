Gem::Specification.new do |s|
  s.name          = 'tli'
  s.version       = '0.0.4'
  s.date          = '2015-02-19'
  s.summary       = 'TransLate It! A command line tool to translate text from \
                     (and to) almost any language.'
  s.description   = 'With tli you can translate text and find definitions using\
                     services like Google Translate, Yandex, Cambridge \
                     dictionaries, etc. All in one.'
  s.authors       = ['Rafael Rendón Pablo']
  s.email         = 'rafaelrendonpablo@gmail.com'
  s.files         = `git ls-files -- lib/* assets/* db/*`.split("\n")
  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/rendon/tli'
  s.license       = 'GNU GPL v3.0'
end
