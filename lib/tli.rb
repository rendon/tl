require 'readline'
require_relative 'translators/google_translator'
require_relative 'dictionaries/google_dictionary'
require_relative 'help'

class Tli
  include Help
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
    params = Hash.new('')
    params[:service] = 'google'
    words = []
    count_words = 0
    index = 0
    while index < length
      arg = args[index]
      if OPTIONS.include?(arg)
        if OPTIONS[arg] == :key_value
          raise "#{arg} requires a value." if index + 1 >= length
          params[arg] = args[index+1]
          index += 1
        else
          params[arg] = :on
        end
      else
        words << arg
      end
      index += 1
    end

    if params['--help'] == :on
      stdout.puts help
      return 0
    end

    exit_code = 0
    OPTIONS.each do |key, value|
      if value == :key_value && params[key].empty?
        stderr.puts "Please provide a value for #{key}"
        exit_code = 1
      end
    end
    return exit_code if exit_code > 0

    if !words.empty?
      stdout.puts process_input(words, params)
    else
      while buf = Readline.readline('> ', true)
        words = buf.split(/\s+/)
        stdout.puts process_input(words, params)
      end
    end
    return exit_code
  end

  def translate(text, source, target, service)
    TRANSLATORS[service].translate(text, source, target)
  end

  def define(word, source, target, service)
    DICTIONARIES[service].define(word, source, target)
  end

  private
    def process_input(words, params)
      if words.length > 1
        translate(words.join(' '),
                  params['--source'],
                  params['--target'],
                  params[:service])
      else
        define(words.join(' '),
               params['--source'],
               params['--target'],
               params[:service])
      end
    end
end
