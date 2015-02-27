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
      @tli.translate('', 'en', 'es', 'google')
    end

    it 'returns the exact text if no translation is found' do
      text = 'lksjdflskdjfiuiiu'
      expect(@fake_stdout).to receive(:puts).with(text)
      @tli.translate(text, 'en', 'es', 'google')
    end

    it 'uses a translator for multiple word text' do
      expect(@tli).to receive(:translate)
      @tli.invoke(%w(--source en --target es --service google a book))
    end

    it 'uses default source if --source is not present' do
      expect(@tli).to receive(:translate).with('a book', 'en', 'es',
                                               'google', *any_args)
      @tli.invoke(%w(--target es --service google a book))
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
                                            'google', *any_args)
      @tli.invoke(%w(--source en --target es --service google book))
    end

    it 'uses default target if --target is not present' do
      expect(@tli).to receive(:define).with('book', 'en', 'es',
                                            'google', *any_args)
      @tli.invoke(%w(--source en --service google book))
    end

    it 'uses default service if --service is not present' do
      expect(@tli).to receive(:define).with('book', 'en', 'es',
                                            'google', *any_args)
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

  describe 'cache translations' do
    it 'checks if the translation is in the local database' do
      expect(Translation).to receive(:find_by)
      @tli.invoke(%w(--cache_results --source en
                     --target es --service google book))
    end
  end

  describe 'configuration file' do
    it 'target and source from config file' do
      config = '{"settings":{"source":"es","target":"en","service":"google"}}'
      allow(File).to receive(:read).with(Application.app_dir + '/tli.conf')
        .and_return(config)
      expect(@tli).to receive(:define).with('fe', 'es', 'en',
                                            'google', *any_args)
      @tli.invoke(%w(fe))
    end

    it 'play from config file' do
      config = '{"settings":{"source":"en","target":"es","play":true}}'
      allow(File).to receive(:read).with(Application.app_dir + '/tli.conf')
        .and_return(config)
      expect(@tli).to receive(:define).with('admonition', 'en', 'es', 'google',
                                            tts: true, cache_results: false)
      @tli.invoke(%w(admonition))
    end

    it 'command line options override config file settings' do
      config = '{"settings":{"source":"en","target":"es","service":"google"}}'
      allow(File).to receive(:read).with(Application.app_dir + '/tli.conf')
        .and_return(config)
      expect(@tli).to receive(:define).with('song', 'en', 'fr',
                                            'google', *any_args)
      @tli.invoke(%w(--target fr song))
    end
  end

  describe 'service info' do
    it { expect(@tli).to respond_to(:info) }

    it 'displays google info' do
      expect(@tli).to receive(:info).with('google')
      @tli.invoke(%w(--info google))
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
    it 'play pronunciation of a word' do
      expect(Player).to receive(:play)
      @tli.invoke(%w(--play music))
    end

    it 'play pronunciation of a text' do
      expect(Player).to receive(:play)
      @tli.invoke(%w(--play music is lovely))
    end
  end

  describe 'service info' do
    it 'displays service info for google' do
      expect(@fake_stdout).to receive(:puts).with(@tli.info('google'))
      @tli.invoke(%w(--info google))
    end
  end

  describe 'list translation services' do
    it 'displays list of translation services' do
      expect(@fake_stdout).to receive(:puts).with(@tli.list_services)
      @tli.invoke(%w(--lts))
    end
  end
end
