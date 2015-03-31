require 'spec_helper'

RSpec.describe String do
  it { expect('Ŵ'.to_binary).to eq('1100010110110100') }
  it { expect('⋙'.to_binary).to eq('111000101000101110011001') }
end