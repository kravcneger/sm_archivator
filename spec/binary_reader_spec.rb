require 'spec_helper'

RSpec.describe BinaryReader do
  
  # 11100011 11111111 10000000 00000111
  # stream - 11100011 11111111 1 (17), closed bytes - 0000000, count of closed bytes - 00000111 (7)
  let(:stream) { '111000111000000000000111' }
  let(:binary_reader){ BinaryReader.new('11100011111111111000000000000111') }

  it "#size_of_data" do
    expect(binary_reader.size_of_data).to eq(17)
  end

  it "#read_bit" do
    bits = [1,1,1,0,0,0,1,1,1, 1, 1, 1, 1, 1, 1, 1, 1]
    bits.each do |bit|
      expect(binary_reader.read_bit).to eq(bit == 1)
    end
    
    expect { binary_reader.read_bit }.to raise_error(BinaryReader::StreamEnded)
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

    def stream(char)
      char.delete(' ') + '00000000'
    end

    it 'correct symbol' do
      symbols.each_index do |k|
        expect(binary_reader.set_stream!( stream(chars[k].delete(' ')) ).read_utf8_char).to eq(symbols[k])
      end
      
      binary_reader.set_stream!( stream(char_one_byte + char_two_bytes + char_three_bytes) )

      symbols.each do |symbol|
        expect(binary_reader.read_utf8_char).to eq(symbol)
      end
    end

    it 'incorrect symbol' do
      ['1111 1111', '1011 1111', '1100 1111 1111 1111 1111 1111'].each do |byte|
        st = stream(byte)
        binary_reader.set_stream!(st)
        expect { binary_reader.read_utf8_char }.to raise_error(BinaryReader::IncorrectUtf8Char)
      end
    end    

  end

 
end