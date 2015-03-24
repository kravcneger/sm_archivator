class Node
  
  attr_accessor :ch, :freq, :left, :right

  def initialize(ch, freq, left = nil, right = nil)
    @ch = ch
    @freq = freq
    @left = left
    @right = right
  end

  def is_leaf?
    @left.nil? && @right.nil?
  end  
end