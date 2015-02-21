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
      expect(@tli).to receive(:translate).with('a book', 'en', 'es', 'google')
      @tli.invoke(%w{--source en --target es --service google a book})
    end

    it 'uses default source if --source is not present' do
      expect(@tli).to receive(:translate).with('a book', 'en', 'es', 'google')
      @tli.invoke(%w{--target es --service google a book},
                  @fake_stdin, @fake_stdout, @fake_stderr)
    end

    it 'uses default target if --target is not present' do
      expect(@tli).to receive(:define).with('book', 'en', 'es', 'google')
      @tli.invoke(%w{--source en --service google book},
                  @fake_stdin, @fake_stdout, @fake_stderr)
    end

    it 'uses default service if --service is not present' do
      expect(@tli).to receive(:define).with('book', 'en', 'es', 'google')
      @tli.invoke(%w{--source en --target es book},
                  @fake_stdin, @fake_stdout, @fake_stderr)
    end

    it 'fails if the options syntax is not correct' do
      expect { @tli.invoke(%w{--source en --target}) }.to raise_error
    end
  end
end
