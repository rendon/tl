require 'spec_helper'
describe Playable do
  before :each do
    @playable_class = Class.new { include Playable }.new
  end

  it 'responds to the #play_pronunciation method' do
    expect(@playable_class).to respond_to(:play_pronunciation).with(1).argument
  end
end
