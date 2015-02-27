require 'spec_helper'

describe StringUtil do
  describe '#translation_id' do
    it { expect(StringUtil).to respond_to(:tts_file_name).with(3).argument }
    it { expect(StringUtil).to respond_to(:tts_hash).with(3).argument }

    context 'unit tests' do
      it do
        pattern = '/pronunciations/a4537bb884ba092961dc5442e8e43f176bcad812.mp3'
        expect(StringUtil.tts_file_name('a book', 'en', 'google'))
          .to end_with pattern
      end
    end
  end
end
