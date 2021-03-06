require 'spec_helper'

describe Tli do
  before :each do
    @fake_stdin = StringIO.new
    @fake_stdout = StringIO.new
    @fake_stderr = StringIO.new
    @tli = Tli.new(Readline, @fake_stdin, @fake_stdout, @fake_stderr)
  end
  describe '#translate' do
    # before { skip }
    it 'responds to the #traslate method' do
      expect(@tli).to respond_to(:translate).with(4).arguments
    end

    it 'returns empty string for empty text' do
      expect(@fake_stdout).to receive(:puts).with('')
      @tli.translate('', 'en', 'es', 'yandex')
    end

    it 'returns the exact text if no translation is found' do
      text = 'lksjdflskdjfiuiiu'
      expect(@fake_stdout).to receive(:puts).with(text)
      @tli.translate(text, 'en', 'es', 'yandex')
    end

    it 'uses a translator for multiple word text' do
      expect(@tli).to receive(:translate)
      @tli.invoke(%w(--source en --target es --service yandex a book))
    end

    it 'uses default source if --source is not present' do
      expect(@tli).to receive(:translate).with('a book', 'en', 'es',
                                               'yandex', *any_args)
      @tli.invoke(%w(--target es --service yandex a book))
    end

    it 'fails if the options syntax is not correct' do
      expect { @tli.invoke(%w(--source en --target)) }.to raise_error
    end
  end

  describe '#define' do
    # before { skip }
    it 'responds to the #define method' do
      expect(@tli).to respond_to(:define).with(4).arguments
    end

    it 'uses a dictionary for single word' do
      expect(@tli).to receive(:define).with('book', 'en', 'es',
                                            'yandex', *any_args)
      @tli.invoke(%w(--source en --target es --service yandex book))
    end

    it 'uses default target if --target is not present' do
      expect(@tli).to receive(:define).with('book', 'en', 'es',
                                            'yandex', *any_args)
      @tli.invoke(%w(--source en --service yandex book))
    end

    it 'uses default service if --service is not present' do
      expect(@tli).to receive(:define).with('book', 'en', 'es',
                                            'yandex', *any_args)
      @tli.invoke(%w(--source en --target es book))
    end
  end

  describe '#invoke' do
    it 'does not process empty strings in interactive mode' do
      readline = double('readline')
      allow(readline).to receive(:readline).and_return('', nil)
      @interactive_tli = Tli.new(readline)
      expect(@fake_stdout).not_to receive(:puts)
      @interactive_tli.invoke([])
    end

    it 'displays help' do
      expect(@fake_stdout).to receive(:puts).with(@tli.help)
      @tli.invoke(%w(--help))
    end
  end

  #describe 'cache translations' do
  #  it 'checks if the translation is in the local database' do
  #    expect(Translation).to receive(:find_by)
  #    @tli.invoke(%w(--cache_results --source en
  #                   --target es --service yandex book))
  #  end
  #end

  describe 'configuration file' do
    it 'target and source from config file' do
      config = '{"settings":{"source":"es","target":"en","service":"yandex"}}'
      conf_file = Application.app_dir + '/tli.conf'
      allow(File).to receive(:exist?).with(conf_file).and_return(true)
      allow(File).to receive(:read).with(conf_file).and_return(config)
      expect(@tli).to receive(:define).with('fe', 'es', 'en',
                                            'yandex', any_args)
      @tli.invoke(%w(fe))
    end

    it 'play from config file' do
      config = '{"settings":{"source":"en","target":"es","play":true}}'
      conf_file = Application.app_dir + '/tli.conf'
      allow(File).to receive(:exist?).with(conf_file).and_return(true)
      allow(File).to receive(:read).with(conf_file).and_return(config)

      params = { tts: true, cache_results: false, player: 'touch' }
      expect(@tli).to receive(:define).with('admonition', 'en', 'es', 'yandex',
                                            params)
      @tli.invoke(%w(admonition))
    end

    it 'command line options override config file settings' do
      config = '{"settings":{"source":"en","target":"es","service":"yandex"}}'
      conf_file = Application.app_dir + '/tli.conf'
      allow(File).to receive(:read).with(conf_file).and_return(config)
      expect(@tli).to receive(:define).with('song', 'en', 'fr',
                                            'yandex', *any_args)
      @tli.invoke(%w(--target fr song))
    end
  end

  describe 'service info' do
    it { expect(@tli).to respond_to(:info) }

    it 'displays yandex info' do
      expect(@tli).to receive(:info).with('yandex')
      @tli.invoke(%w(--info yandex))
    end

    it 'handles unknown services' do
      expect do
        @tli.invoke(%w(--info *#!_?-))
      end.to raise_error(StandardError, 'Unknown service')
    end
  end

  describe 'display supported services' do
    it { expect(@tli).to respond_to(:list_services) }
    it 'displays list of supported services' do
      expect(@tli).to receive(:list_services)
      @tli.invoke(%w(--lts))
    end
  end

  describe 'deal with options' do
    it 'refuses invalid options' do
      expect do
        @tli.invoke(%w(--source en --target es --book in my book))
      end.to raise_error(StandardError, '--book: not a valid option')
    end
  end

  describe 'play pronunciation' do
#    it 'play pronunciation of a word' do
#      expect(Player).to receive(:play)
#      @tli.invoke(%w(--play music))
#    end
#
#    it 'play pronunciation of a text' do
#      expect(Player).to receive(:play)
#      @tli.invoke(%w(--play music is lovely))
#    end
  end

  describe 'service info' do
    it 'displays service info for yandex' do
      expect(@fake_stdout).to receive(:puts).with(@tli.info('yandex'))
      @tli.invoke(%w(--info yandex))
    end
  end

  describe 'list translation services' do
    it 'displays list of translation services' do
      expect(@fake_stdout).to receive(:puts).with(@tli.list_services)
      @tli.invoke(%w(--lts))
    end
  end

  describe 'use custom player' do
    #it 'uses user-specified player' do
    #  audio_file = StringUtil.tts_file_name('light', 'en', 'yandex')
    #  expect(Player).to receive(:play).with(audio_file, 'mplayer')
    #  @tli.invoke(%w(--play --player mplayer light))
    #end

    #it 'user player from config file' do
    #  config = '{"settings":{"play":true,"player":"play"}}'
    #  conf_file = Application.app_dir + '/tli.conf'
    #  audio_file = StringUtil.tts_file_name('light', 'en', 'yandex')
    #  allow(File).to receive(:exist?).with(conf_file).and_return(true)
    #  allow(File).to receive(:exist?).with(audio_file).and_return(true)
    #  allow(File).to receive(:read).with(conf_file).and_return(config)
    #  expect(Player).to receive(:play).with(audio_file, 'play')
    #  @tli.invoke(%w(light))
    #end
  end

  describe '--version' do
    it 'displays version information' do
      expect(@fake_stdout).to receive(:puts).with(@tli.version)
      @tli.invoke(%w(--version))
    end
  end
end
