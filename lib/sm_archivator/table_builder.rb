class TableBuilder
  def self.build(root)
    table = {}
    buildCode(table, root, '')
    return table
  end

  private

  def self.buildCode(table, node, s)
    if node
      if node.is_leaf?
        table[node.ch] = s
        return
      end
      buildCode(table, node.left, s + '0')
      buildCode(table, node.right, s + '1')
    end
  end 
end