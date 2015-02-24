require 'spec_helper'

describe StringUtil do
  describe '#translation_id' do
    it 'responds to the #tts_file_name method' do
      expect(StringUtil).to respond_to(:tts_file_name).with(4).argument
    end

    context 'unit tests' do
      it {
        expect(StringUtil.tts_file_name('a book', 'en', 'es', 'google')) .to end_with '/pronunciations/bc62dc11793bc8fa94b755cf0a725d0ce96fb9b4.mp3'
      }
    end
  end
end
