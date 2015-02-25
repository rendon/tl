# encoding: utf-8
require 'spec_helper'

describe GoogleTranslator do
  before :each do
    @translator = GoogleTranslator.new
  end

  describe '#name' do
    it { expect(GoogleTranslator).to respond_to(:name) }
    it { expect(GoogleTranslator.name).not_to be_nil   }
  end

  describe '#provide_tts?' do
    it { expect(@translator).to respond_to(:provide_tts?) }
    it { expect(@translator.provide_tts?).to be true }
  end

  describe '#get_langs' do
    it { expect(@translator).to respond_to(:get_langs) }

    it { expect(@translator.get_langs).to include('en') }
    it { expect(@translator.get_langs).to include('es') }
  end

  describe '#translate' do
    it { expect(@translator).to respond_to(:translate).with(3).arguments }

    it 'should fail when source code is not supported' do
      expect {
        @translator.translate('text', 'English', 'es')
      }.to raise_error
    end

    it 'should fail when target code is not supported' do
      expect {
        @translator.translate('text', 'en', 'Spanish')
      }.to raise_error
    end

    it 'translates from English to Spanish' do
      text = 'What is your name?'
      result = 'Cuál es tu nombre?'
      expect(@translator.translate(text, 'en', 'es')).to include(result)
    end

    it 'translates from Spanish to Russian' do
      text = 'Que tengas un buen día.'
      result = 'Хорошего дня.'
      expect(@translator.translate(text, 'es', 'ru')).to include(result)
    end

    it 'translates from French to Spanish' do
      text = 'Mon ami.'
      result = 'Mi amigo.'
      expect(@translator.translate(text, 'fr', 'es')).to include(result)
    end

    it 'translates from Spanish to Japanese' do
      text = 'de vez en cuando'
      result = '時折'
      expect(@translator.translate(text, 'es', 'ja')).to include(result)
    end

    it 'downloads pronunciation the first time' do
      expect(@translator).to receive(:get_pronunciation)
      @translator.translate('book', 'en', 'es', tts: true, cache_results: true)
    end

    it 'uses cached pronunciation' do
      @translator.translate('book', 'en', 'es', tts: true, cache_results: true)
      expect(@translator).not_to receive(:get_pronunciation)
      @translator.translate('book', 'en', 'es', tts: true, cache_results: true)
    end
  end

  describe '#get_info' do
    it { expect(GoogleTranslator).to respond_to(:get_info) }
    it { expect(GoogleTranslator.get_info).not_to be_nil }
  end
end
