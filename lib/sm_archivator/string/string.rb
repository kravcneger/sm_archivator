class String
  
  def to_binary
    self.unpack("B*")[0].to_s
  end

end