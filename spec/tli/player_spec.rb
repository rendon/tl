require 'spec_helper'

describe Player do
  it 'responds to the #play method' do
    expect(Player).to respond_to(:play).with(1).argument
  end
end
