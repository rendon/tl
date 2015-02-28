require 'spec_helper'

describe Player do
  it 'responds to the #play method' do
    expect(Player).to respond_to(:play).with(2).argument
  end
end
