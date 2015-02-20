# encoding: utf-8
require 'spec_helper'

describe GoogleTranslator do
  before :each do
    @translator = GoogleTranslator.new
  end

  describe '#get_langs' do
    it 'should respond to the #get_langs method' do
      expect(@translator).to respond_to(:get_langs)
    end

    it 'should contain "en" key' do
      expect(@translator.get_langs).to include('en')
    end
    it 'should contain "es" key' do
      expect(@translator.get_langs).to include('es')
    end
  end

  describe '#translate' do

    it 'should respond to the #translate method' do
      expect(@translator).to respond_to(:translate).with(3).arguments
    end

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


  end
end
