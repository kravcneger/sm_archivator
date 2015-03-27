class TrieBuilder
  def self.build(str)
    freq = {}
    str.each_char {|c| freq[c] = freq[c] ? freq[c] + 1 : 1 }

    pq = Pq.new

    freq.each do |ch, fr|
      pq.insert(ch, fr, nil, nil)
    end
  
    while pq.size > 1
      x = pq.del_min
      y = pq.del_min
      pq.insert('0', x.freq + (y ? y.freq : 0), x, y)
    end

    return pq    
  end
end