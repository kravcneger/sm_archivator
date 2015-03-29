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
    # ']'    
    let(:char_one_byte){ '0101 1101' }
    # 'Ŵ' - C1 B3
    let(:char_two_bytes){ '1100 0001 1011 0011' }
    # 'ɓ'
    let(:char_three_bytes){ '1110 0001 10110011 10111111' }
    # 'ˎ'
    let(:char_four_bytes){ '11110000 10100111 10110111 1000 0000' }
    let(:symbols){ [']', 'Ŵ', 'ɓ', 'ˎ'] }

    def stream(char)
      char.delete(' ') + '00000000'
    end

    it 'correct symbol' do
      expect(binary_reader.set_stream!( stream(char_one_byte) ).read_utf8_char).to eq(symbols[0])
      expect(binary_reader.set_stream!( stream(char_two_bytes) ).read_utf8_char).to eq(symbols[1])
      
      expect(binary_reader.set_stream!( stream(char_three_bytes) ).read_utf8_char).to eq(symbols[2])
      expect(binary_reader.set_stream!( stream(char_four_bytes) ).read_utf8_char).to eq(symbols[3])
      
      binary_reader.set_stream!( stream(char_one_byte + char_two_bytes + char_three_bytes + char_four_bytes) )

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