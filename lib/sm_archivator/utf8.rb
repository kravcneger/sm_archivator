module Utf8
  class IncorrectChar < StandardError
  end
  
  def self.get_char(str)
    raise IncorrectChar unless valid_char(str)

    size = str.size
    number_bytes = size / 8

    code = 0

    case number_bytes
    when 1
      code = str[1,7].to_i(2)
    else
      st = str[ number_bytes + 1, 8 - number_bytes -1 ]
      (8...size).step(8) do |range|
        st += str[range + 2, 6]
      end
      code = st.to_i(2)
    end

    [code].pack('U')
  end

  private
  
  def self.valid_char(str)
    str.size % 8 == 0 && str.size >= 8    
  end
end