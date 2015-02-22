# encoding: utf-8
require 'spec_helper'

describe GoogleDictionary do
  before :each do
    @dictionary = GoogleDictionary.new
  end

  describe "#get_langs" do
    it 'should respond to the #get_langs method' do
      expect(@dictionary).to respond_to(:get_langs)
    end

    it 'should contain "en" key' do
      expect(@dictionary.get_langs).to include('en')
    end

    it 'should contain "es" key' do
      expect(@dictionary.get_langs).to include('es')
    end
  end

  describe "#define" do
    it 'should respond to the #define method' do
      expect(@dictionary).to respond_to(:define).with(3).arguments
    end

    it 'should fail when source code is not supported' do
      expect {
        @dictionary.define('text', 'English', 'es')
      }.to raise_error
    end

    it 'should fail when target code is not supported' do
      expect {
        @dictionary.define('text', 'en', 'Spanish')
      }.to raise_error
    end

    it 'defines from Spanish to Russian' do
      text = 'deseo'
      result = 'желание'
      expect(@dictionary.define(text, 'es', 'ru')).to include(result)
    end

    it 'defines from French to Spanish' do
      text = 'sommeil'
      result = 'sueño'
      expect(@dictionary.define(text, 'fr', 'es')).to include(result)
    end

    it 'defines "car" from English to Spanish' do
      word = 'car'
      definition = @dictionary.define(word, 'en', 'es')
      expect(definition).to include('noun')
      expect(definition).to include('coche')
      expect(definition).to include('vagón')
      expect(definition).to include('auto')
      expect(definition).to include('automóvil')
      expect(definition).to include('carro')
      expect(definition).to include('máquina')
    end

    it 'defines "light" from English to Spanish' do
      word = 'light'
      definition = @dictionary.define(word, 'en', 'es')
      expect(definition).to include('noun')
      expect(definition).to include('luz')

      expect(definition).to include('adjective')
      expect(definition).to include('de luz')
      expect(definition).to include('ligero')

      expect(definition).to include('verb')
      expect(definition).to include('iluminar')
      expect(definition).to include('alumbrar')

      expect(definition).to include('adverb')
      expect(definition).to include('ligeramente')
    end

    it 'defines "pensamiento" from Spanish to English' do
      word = 'pensamiento'
      definition = @dictionary.define(word, 'es', 'en')
      expect(definition).to include('noun')
      expect(definition).to include('thought')
      expect(definition).to include('thinking')
    end

    it 'defines "alto" from Spanish to English' do
      word = 'alto'
      definition = @dictionary.define(word, 'es', 'en')
      expect(definition).to include('adjective')
      expect(definition).to include('high')
      expect(definition).to include('tall')

      expect(definition).to include('noun')
      expect(definition).to include('stop')
      expect(definition).to include('halt')

      expect(definition).to include('adverb')
      expect(definition).to include('loud')
      expect(definition).to include('aloud')
    end

    it 'calls #play_pronunciation when the "play" argument is true' do
      expect(@dictionary).to receive(:play_pronunciation)
      @dictionary.define('hi', 'en', 'es', true)
    end
  end

  describe '#play_pronunciation' do
    it 'responds to the #play_pronunciation method' do
      expect(@dictionary).to respond_to(:play_pronunciation).with(1).argument
    end
  end
end
