module Utf8
  class IncorrectChar < StandardError
  end
  
  def self.get_char(str)
    raise IncorrectChar unless valid_char(str)

    size = str.size
    number = 0
    (0..size).step(8) do |range|
      number += str[range,8].to_i(2)
    end

    [number].pack('U')
  end

  private
  
  def self.valid_char(str)
    str.size % 8 == 0 && str.size >= 8    
  end
end