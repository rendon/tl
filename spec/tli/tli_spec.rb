require 'spec_helper'

describe Tli do
  describe "#translate" do
    it "returns empty string for empty text" do
      expect(Tli.translate("", {source: 'en', target: 'es'})).to be_empty
    end

    it "returns the exact text if no translation is found" do
      text = "lksjdflskdjfiuiiu"
      expect(Tli.translate(text, {source: 'en', target: 'es'})).to eq(text)
    end
  end
end
