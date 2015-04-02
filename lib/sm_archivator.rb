require "sm_archivator/version"
require "sm_archivator/string/string"
require "sm_archivator/pq"
require "sm_archivator/node"
require "sm_archivator/trie_builder"
require "sm_archivator/table_builder"
require "sm_archivator/binary_stream"
require "sm_archivator/utf8"

module SmArchivator

  def self.compress(str)
    @@binary_stream.clear_stream!

    tree = TrieBuilder.build(str).min
    self::write_tree(tree)

    table = TableBuilder.build(tree)

    str.each_char do |ch|
      table[ch].each_char do |bit|
        @@binary_stream.write_bit!(bit)
      end
    end

    @@binary_stream.close_stream!
    @@binary_stream.all_stream
  end


  def self.expand(str)
    @@binary_stream.set_stream!(str)
    @@binary_stream.remove_last_bits!

    result = ''
    root = self::read_trie

    while !@@binary_stream.in_end?
      x = root

      while !x.is_leaf?
        if @@binary_stream.read_bit == '1'
          x = x.right
        else
          x = x.left
        end
      end
      result += x.ch
    end
    result
  end

  private

  @@binary_stream = BinaryStream.new

  def self.write_tree(node)
    return unless node

    if(node.is_leaf?)
      @@binary_stream.write_bit!('1')
      @@binary_stream.write_char!(node.ch)
      return
    end
    @@binary_stream.write_bit!('0')

    self::write_tree(node.left)
    self::write_tree(node.right)
  end

  def self.read_trie
    if @@binary_stream.read_bit == '1'
      return Node.new(@@binary_stream.read_utf8_char, 0, nil, nil)
    end
    return Node.new('0', 0, self::read_trie, self::read_trie)
  end

end
