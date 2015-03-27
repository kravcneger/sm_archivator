require 'spec_helper'

RSpec.describe TrieBuilder do

  #  str = ACCCCAAAADBB                           
  #       A.5                    0.12            
  #   B.2     C.4    ==>        /   \   
  # D.1                      A.5    0.7    
  #                                /   \ 
  #                             3.0     C.4
  #                          D.1   B.2
  it "#build" do
    expect(TrieBuilder::build('ACCCCAAAADBB').direct_bypass).to eq([['0',12], ['A',5], ['0',7], 
                                                                   ['0',3], ['D',1], ['B', 2], ['C', 4]])
  end
end