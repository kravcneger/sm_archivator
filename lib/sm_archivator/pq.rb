class Pq
  def initialize
    @nodes = [0]
  end
  
  def insert(ch, freq, x = nil, y = nil)
    if @nodes[1]
      @nodes.push(Node.new(ch, freq, x, y))
      swim(size)
    else
      @nodes[1] = Node.new(ch, freq, x, y)
    end
  end

  def size
    @nodes.size - 1
  end

  def del_min
    min = self.min
    exch(1, size)
    @nodes.pop
    sink(1)
    min
  end

  def min
    @nodes[1]
  end

  def direct_bypass
    Pq::direct_bypass(min)
  end

  def self.direct_bypass(node, bypass = [])
    node = node.min if node.class == Pq
    if node
      bypass.push([node.ch, node.freq])
      direct_bypass(node.left, bypass)
      direct_bypass(node.right, bypass)
    end
    return bypass
  end

  private

  def less(i, j)
    @nodes[i].freq > @nodes[j].freq
  end

  def exch(i, j)
    t = @nodes[i]
    @nodes[i] = @nodes[j]
    @nodes[j] = t
  end

  def swim(k)
    while k > 1 && less( (k/2).to_i , k)
      exch( (k/2).to_i , k)
      k = (k/2).to_i
    end
  end

  def sink(k)
    while 2*k <= size
      j = 2*k

      j += 1 if j < size && less(j, j+1)
      break unless less(k, j)

      exch(k ,j)
      k = j
    end
  end

end