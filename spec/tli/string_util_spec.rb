require 'spec_helper'

describe StringUtil do
  describe '#translation_id' do
    it 'responds to the #translation_id method' do
      expect(StringUtil).to respond_to(:translation_id).with(4).argument
    end

    context 'unit tests' do
      it { expect(StringUtil.translation_id('a book', 'en', 'es', 'google')) .to be == 'bc62dc11793bc8fa94b755cf0a725d0ce96fb9b4' }
    end
  end
end
