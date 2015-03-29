class BinaryReader
  class StreamEnded < StandardError
  end

  class IncorrectUtf8Char < StandardError
  end

  def initialize(stream)
    set_stream!(stream)
  end

  def set_stream!(stream)
    @stream = stream
    last_byte = @stream[-8,8].to_i(2)
    @size = @stream.size - 8 - last_byte
    @pointer = 0
    self
  end
  
  def read_bit
    raise StreamEnded if is_empty?
    bit = @stream[@pointer]
    @pointer += 1
    bit == '1'
  end
  
  # Reads char in utf-8 encode
  def read_utf8_char
    bytes = 1
    units = 0    
    self_current = @pointer

    while read_bit
      units += 1
      
      if units > 1
        bytes += 1
      end

      if units > 6
        raise IncorrectUtf8Char
      end        
    end

    raise IncorrectUtf8Char if units == 1 || (self_current + bytes * 8) > size_of_data
    # (1 байт)  0aaa aaaa 
    # (2 байта) 110x xxxx 10xx xxxx
    # (3 байта) 1110 xxxx 10xx xxxx 10xx xxxx
    # (4 байта) 1111 0xxx 10xx xxxx 10xx xxxx 10xx xxxx
    # (5 байт)  1111 10xx 10xx xxxx 10xx xxxx 10xx xxxx 10xx xxxx
    # (6 байт)  1111 110x 10xx xxxx 10xx xxxx 10xx xxxx 10xx xxxx 10xx xxxx
    1.upto(units-1) do |i|
      raise IncorrectUtf8Char if @stream[self_current + i*8,2] != '10'
    end 

    @pointer = self_current + bytes * 8

    Utf8::get_char(@stream[self_current...@pointer])
  end

  def is_empty?
    !(@pointer < size_of_data)
  end

  def size_of_data
    @size
  end
  
end