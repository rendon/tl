require 'spec_helper'

describe Tli do
  describe "#translate" do
    it "returns empty string for empty text" do
      expect(Tli.translate("", 'en', 'es')).to be_empty
    end

    it "returns the exact text if no translation is found" do
      text = "lksjdflskdjfiuiiu"
      expect(Tli.translate(text, 'en', 'es')).to eq(text)
    end
  end
end
