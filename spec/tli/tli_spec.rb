require 'spec_helper'

describe Tli do
  describe "#translate" do
    it 'responds to the #traslate method' do
      expect(Tli).to respond_to(:translate).with(4).arguments
    end

    it 'returns empty string for empty text' do
      expect(Tli.translate("", 'en', 'es', 'google')).to be_empty
    end

    it "returns the exact text if no translation is found" do
      text = "lksjdflskdjfiuiiu"
      expect(Tli.translate(text, 'en', 'es', 'google')).to eq(text)
    end

    it 'uses a dictionary for single word' do
      expect(Tli).to receive(:define).with('book', 'en', 'es', 'google')
      Tli.invoke(%w{--source en --target es --service google book})
    end

    it 'uses a translator for multiple word text' do
      expect(Tli).to receive(:translate).with('two books', 'en', 'es', 'google')
      Tli.invoke(%w{--source en --target es --service google two books})
    end

    it 'fails if --source is not present' do
      expect(Tli.invoke(%w{--target es --service google book})).not_to eq(0)
    end

    it 'fails if --target is not present' do
      expect(Tli.invoke(%w{--source en --service google book})).not_to eq(0)
    end

    it 'fails if --service is not present' do
      expect(Tli.invoke(%w{--source en --target es google book})).not_to eq(0)
    end
  end
end
