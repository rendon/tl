require_relative 'translators/google_translator'
require_relative 'dictionaries/google_dictionary'
require_relative 'help'

class Tli
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

  def self.invoke(args)
    length = args.length
    params = Hash.new('')
    params[:service] = 'google'
    params[:text] = []
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
        params[:text] << arg
        count_words += 1
      end
      index += 1
    end

    if params['--help'] == :on
      puts Help.help
      return 0
    end

    exit_code = 0
    OPTIONS.each do |key, value|
      if value == :key_value && params[key].empty?
        STDERR.puts "Please provide a value for #{key}"
        exit_code = 1
      end
    end

    return exit_code if exit_code > 0

    if count_words > 1
      puts translate(params[:text].join(' '), params['--source'], params['--target'], params[:service])
    else
      puts define(params[:text].join(' '), params['--source'], params['--target'], params[:service])
    end
    return exit_code
  end

  def self.translate(text, source, target, service)
    TRANSLATORS[service].translate(text, source, target)
  end

  def self.define(word, source, target, service)
    DICTIONARIES[service].define(word, source, target)
  end
end
