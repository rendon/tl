# encoding: utf-8
require 'spec_helper'

describe GoogleDictionary do
  before :each do
    @dictionary = GoogleDictionary.new
  end

  describe '#name' do
    it { expect(GoogleDictionary).to respond_to(:name) }
    it { expect(GoogleDictionary.name).not_to be_nil   }
  end

  describe '#provide_tts?' do
    it { expect(@dictionary).to respond_to(:provide_tts?) }
    it { expect(@dictionary.provide_tts?).to be true }
  end

  describe '#langs' do
    it { expect(@dictionary).to respond_to(:langs) }
    it { expect(@dictionary.langs).to include('en') }
    it { expect(@dictionary.langs).to include('es') }
  end

  describe '#define' do
    it { expect(@dictionary).to respond_to(:define).with(3).arguments }

    it 'fails when source code is not supported' do
      expect { @dictionary.define('text', 'English', 'es') }.to raise_error
    end

    it 'fails when target code is not supported' do
      expect { @dictionary.define('text', 'en', 'Spanish') }.to raise_error
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
  end
end
