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
  end
  
  def self.expand(str)
  end

  private

  def size_archived_data(str)
    # How much bytes was allocated to record the number of characters 
    # without tree
    first_byte = @stream[0, 8].to_i(2)
    
    # Contains number of missing bits
    # stream - 01100_000 closed byte 00000011 = 3 bit
    closed_byte = str[-8, 8]


    @stream[8, first_byte * 8].to_i(2)
  end
  
  def set_size_of_archived_data
    
  end
end
