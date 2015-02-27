# encoding: utf-8
require 'readline'
require_relative 'translators/google_translator'
require_relative 'dictionaries/google_dictionary'
require_relative 'help'
require_relative 'translation'

# Command Line Interface for the translator
class Tli
  include Help
  DEFAULTS = {
    service: 'google',
    source: 'en',
    target: 'es'
  }

  OPTIONS = {
    source:         :key_value,
    target:         :key_value,
    service:        :key_value,
    info:           :key_value,
    cache_results:  :flag,
    play:           :flag,
    help:           :flag,
    lts:            :flag
  }

  SERVICES = {
    'google' => GoogleTranslator
  }

  TRANSLATORS = {
    'google'  => GoogleTranslator.new
  }

  DICTIONARIES = {
    'google'  => GoogleDictionary.new
  }

  attr_reader :stdin, :stdout, :stderr

  def initialize(readline = Readline, stdin = $stdin,
                 stdout = $stdout, stderr = $stderr)
    @readline = readline
    @stdin = stdin
    @stdout = stdout
    @stderr = stderr
  end

  def invoke(args)
    params = parse_options(args)
    params = read_config_file(params)

    return stdout.puts help                 if params[:help] == true
    return stdout.puts list_services        if params[:lts] == true
    return stdout.puts info(params[:info])  unless params[:info].empty?

    params[:source]  = DEFAULTS[:source]    if params[:source].empty?
    params[:target]  = DEFAULTS[:target]    if params[:target].empty?
    params[:service] = DEFAULTS[:service]   if params[:service].empty?

    if !params[:words].empty?
      process_input(params)
    else
      while buf = @readline.readline('> ', true)
        params[:words] = buf.split(/\s+/)
        process_input(params)
      end
    end
  end

  def translate(text, source, target, service, options = {})
    result = TRANSLATORS[service].translate(text, source, target, options)
    if options[:tts] && TRANSLATORS[service].provide_tts?
      stdout.puts '♬'
      stdout.puts result
      file_name = StringUtil.tts_file_name(text, target, service)
      Player.play(file_name)
    else
      stdout.puts result
    end
  end

  def define(word, source, target, service, options = {})
    result = DICTIONARIES[service].define(word, source, target, options)
    if options[:tts] && DICTIONARIES[service].provide_tts?
      stdout.puts '♬'
      stdout.puts result
      file_name = StringUtil.tts_file_name(word, target, service)
      Player.play(file_name)
    else
      stdout.puts result
    end
  end

  def parse_options(args)
    length = args.length
    params = Hash.new('')
    params[:words] = []
    index = 0
    while index < length
      arg = args[index]
      unless arg.start_with?('--')
        params[:words] << arg
        index += 1
        next
      end

      sym = arg[2..-1].to_sym
      fail "#{arg}: not a valid option" unless OPTIONS.include?(sym)
      if OPTIONS[sym] == :key_value
        fail "#{arg} requires a value" if index + 1 >= length
        params[sym] = args[index + 1]
        index += 1
      else
        params[sym] = true
      end
      index += 1
    end
    params
  end

  def process_input(params)
    options = {
      tts: params[:play] == true,
      cache_results: params[:cache_results] == true
    }
    if params[:words].length == 1
      define(params[:words].join(' '), params[:source],
             params[:target], params[:service], options)
    elsif params[:words].length > 1
      translate(params[:words].join(' '), params[:source],
                params[:target], params[:service], options)
    end
  end

  def read_config_file(params)
    if File.exist?(Application.app_dir + '/tli.conf')
      config = JSON.parse(File.read(Application.app_dir + '/tli.conf'))
      OPTIONS.each do |key, _|
        if config['settings'][key.to_s] && params[key].empty?
          params[key] = config['settings'][key.to_s]
        end
      end
    end
    params
  end

  def info(service)
    SERVICES[service].info
  end

  def list_services
    list = "Available translation services\n\n"
    list += "id\t\tName\n"
    list += "--\t\t----\n"
    SERVICES.each do |key, value|
      list += "#{key}\t\t#{value.name}"
    end
    list
  end
end
