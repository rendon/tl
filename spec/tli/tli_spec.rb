require 'spec_helper'

describe Tli do
  before :each do
    @fake_stdin = StringIO.new
    @fake_stdout = StringIO.new
    @fake_stderr = StringIO.new
    @tli = Tli.new
  end
  describe "#translate" do
    it 'responds to the #traslate method' do
      expect(@tli).to respond_to(:translate).with(4).arguments
    end

    it 'returns empty string for empty text' do
      expect(@tli.translate("", 'en', 'es', 'google')).to be_empty
    end

    it "returns the exact text if no translation is found" do
      text = "lksjdflskdjfiuiiu"
      expect(@tli.translate(text, 'en', 'es', 'google')).to eq(text)
    end

    it 'uses a dictionary for single word' do
      expect(@tli).to receive(:define).with('book', 'en', 'es', 'google')
      @tli.invoke(%w{--source en --target es --service google book})
    end

    it 'uses a translator for multiple word text' do
      expect(@tli).to receive(:translate).with('two books', 'en', 'es', 'google')
      @tli.invoke(%w{--source en --target es --service google two books})
    end

    it 'fails if --source is not present' do
      expect(@tli.invoke(%w{--target es --service google book},
                        @fake_stdin, @fake_stdout, @fake_stderr)).not_to eq(0)
    end

    it 'fails if --target is not present' do
      expect(@tli.invoke(%w{--source en --service google book},
                       @fake_stdin, @fake_stdout, @fake_stderr)).not_to eq(0)
    end

    it 'fails if --service is not present' do
      expect(@tli.invoke(%w{--source en --target es google book},
                       @fake_stdin, @fake_stdout, @fake_stderr)).not_to eq(0)
    end
  end
end
