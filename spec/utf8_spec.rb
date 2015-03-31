require 'spec_helper'

RSpec.describe Utf8 do
  
  let(:Utf8) { Class.new { extend Utf8 } }

  it "#get_char" do
    # 'Ŵ' - C1 B3
    char = '1100010110110100'.delete(' ')
    expect(Utf8::get_char(char)).to eq('Ŵ')

    # '⋙'
    char = '11100010 10001011 10011001'.delete(' ')
    expect(Utf8::get_char(char)).to eq('⋙')

    expect { Utf8::get_char('10101101111') }.to raise_error(Utf8::IncorrectChar)
  end
end