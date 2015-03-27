require 'spec_helper'

RSpec.describe TableBuilder do

  #  str = ACCCCAAAADBB 
  #          0.12 
  #         /   \ 
  #       A.5    0.7 
  #             /   \ 
  #          3.0     C.4
  #       D.1   B.2
  it "#build" do
    tree = TrieBuilder::build('ACCCCAAAADBB').min

    expect(TableBuilder.build(tree)).to eq({
      'A' => '0',
      'C' => '11',
      'D' => '100',
      'B' => '101'
      })
  end
end