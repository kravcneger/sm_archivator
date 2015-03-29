require 'spec_helper'

RSpec.describe Utf8 do
  
  let(:Utf8) { Class.new { extend Utf8 } }

  it "#get_char" do
    # 'Ŵ' - C1 B3
    char = '1100 0001 1011 0011'.delete(' ')
    expect(Utf8::get_char(char)).to eq('Ŵ')

    # 'ʓ'
    char = '1110 0001 10110011 11111111'.delete(' ')
    expect(Utf8::get_char(char)).to eq('ʓ')

    expect { Utf8::get_char('10101101111') }.to raise_error(Utf8::IncorrectChar)
  end
end