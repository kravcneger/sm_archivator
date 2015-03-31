require 'spec_helper'

RSpec.describe BinaryStream do
  
  # 11100011 11111111 10000000 00000111
  let(:stream) { '111000111000000000000111' }
  let(:binary_stream){ BinaryStream.new('11100011111111111000000000000111') }

  it "#size_of_data" do
    expect(binary_stream.size).to eq(32)
  end

  it "#read_bit" do
    binary_stream.set_stream!('101')
    bits = [1,0,1]
    bits.each do |bit|
      expect(binary_stream.read_bit).to eq(bit.to_s)
    end
    
    expect(binary_stream.in_end?).to eq(true)

    expect { binary_stream.read_bit }.to raise_error(BinaryStream::StreamEnded)
  end

  it "#clear_stream!" do
    expect{ binary_stream.clear_stream! }.to change{binary_stream.size}.from(32).to(0)
  end

  it "#write_bit!" do
    binary_stream.set_stream!('111')
    expect{ binary_stream.write_bit!('0') }.to change{binary_stream.stream}.from('111').to('0111')
  end

  it "#write_char!" do
    binary_stream.set_stream!('11')
    2.times { binary_stream.read_bit }
    expect{ binary_stream.write_char!('d') }.to change{binary_stream.stream}.from('11').to('1101100100')    
  end
  
  describe "read_utf8_char" do
    let!(:chars){ [] }
    # ']'    
    let!(:char_one_byte){ chars[0] = '0101 1101' }
    # 'Ŵ' - C1 B3
    let!(:char_two_bytes){ chars[1] = '11000101 10110100' }
    # '⋙'
    let!(:char_three_bytes){ chars[2] = '11100010 10001011 10011001' }
    let!(:symbols){ [']', 'Ŵ', '⋙'] }

    it 'correct symbol' do
      symbols.each_index do |k|
        expect(binary_stream.set_stream!( chars[k].delete(' ') ).read_utf8_char).to eq(symbols[k])
      end
      
      binary_stream.set_stream!( (char_one_byte + char_two_bytes + char_three_bytes).delete(' ') )

      symbols.each do |symbol|
        expect(binary_stream.read_utf8_char).to eq(symbol)
      end
    end

    it 'incorrect symbol' do
      ['1111 1111', '1011 1111', '1100 1111 1111 1111 1111 1111'].each do |byte|
        binary_stream.set_stream!(byte)
        expect { binary_stream.read_utf8_char }.to raise_error(BinaryStream::IncorrectUtf8Char)
      end
    end    

  end

 
end