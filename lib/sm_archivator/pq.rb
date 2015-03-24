class Pq
  def initialize
    @top = nil
  end

  def top
    @top
  end

  def is_empty?
    top.nil?
  end

  def insert(ch, freq, x = nil, y = nil)
    if @top
      merge!(Node.new(ch, freq, x, y))
    else
      @top = Node.new(ch, freq, x, y)
    end
  end  

  def del_top
    return unless @top
    m = @top
    if @top.left && @top.right
      @top = Heap::merge(@top.left, @top.right)
    elsif @top.left
      @top = @top.left
    elsif @top.right
      @top = @top.right
    else
      @top = nil
    end
    m.left = nil
    m.right = nil
    m
  end

  def merge!(heap)
    @top = Pq::merge(@top, heap)
    self
  end
  
  def direct_bypass
    Pq::direct_bypass(top)
  end

  def self.merge(heap1, heap2)
    heap1 = heap1.class == Pq ? heap1.top : heap1
    heap2 = heap2.class == Pq ? heap2.top : heap2

    return heap1 if heap2.nil?
    return heap2 if heap1.nil?
 
    if heap1.freq >= heap2.freq
      temp = heap1.right
      heap1.right = heap1.left
      heap1.left = Pq::merge(heap2, temp)
      return heap1
    else
      return Pq::merge(heap2, heap1)
    end
  end

  def self.direct_bypass(node, bypass = [])
    node = node.top if node.class == Pq
    if node
      bypass.push([node.ch, node.freq])
      direct_bypass(node.left, bypass)
      direct_bypass(node.right, bypass)
    end
    return bypass
  end

end