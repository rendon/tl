require 'readline'
require_relative 'translators/google_translator'
require_relative 'dictionaries/google_dictionary'
require_relative 'help'

class Tli
  include Help
  DEFAULTS = {
    service: 'google',
    source: 'en',
    target: 'es'
  }

  OPTIONS = {
    '--source'    => :key_value,
    '--target'    => :key_value,
    '--service'   => :key_value,
    '--play'      => :flag,
    '--help'      => :flag
  }

  TRANSLATORS = {
    'google'  => GoogleTranslator.new
  }

  DICTIONARIES = {
    'google'  => GoogleDictionary.new
  }

  def invoke(args, stdin = $stdin, stdout = $stdout, stderr = $stderr)
    length = args.length
    params = parse_options(args)

    if params['--help'] == :on
      stdout.puts help
      return "bye"
    end

    params['--source']  = DEFAULTS[:source]   if params['--source'].empty?
    params['--target']  = DEFAULTS[:target]   if params['--target'].empty?
    params['--service'] = DEFAULTS[:service]  if params['--service'].empty?

    if !params[:words].empty?
      stdout.puts process_input(params)
    else
      while buf = Readline.readline('> ', true)
        params[:words] = buf.split(/\s+/)
        stdout.puts process_input(params)
      end
    end
  end

  def translate(text, source, target, service)
    TRANSLATORS[service].translate(text, source, target)
  end

  def define(word, source, target, service)
    DICTIONARIES[service].define(word, source, target)
  end

  private
    def parse_options(args)
      length = args.length
      params = Hash.new('')
      params[:words] = []
      index = 0
      while index < length
        arg = args[index]
        if OPTIONS.include?(arg)
          if OPTIONS[arg] == :key_value
            raise "#{arg} requires a value" if index + 1 >= length
            params[arg] = args[index+1]
            index += 1
          else
            params[arg] = :on
          end
        else
          params[:words] << arg
        end
        index += 1
      end
      params
    end

    def process_input(params)
      if params[:words].length > 1
        translate(params[:words].join(' '),
                  params['--source'],
                  params['--target'],
                  params['--service'])
      else
        define(params[:words].join(' '),
               params['--source'],
               params['--target'],
               params['--service'])
      end
    end
end
