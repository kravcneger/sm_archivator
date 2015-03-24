require 'spec_helper'

RSpec.describe Pq do
  let(:pq){ Pq.new }
  
  it "#top" do
    expect(pq.top).to eq(nil)
  end

  it "#insert" do
    pq.insert('2',2)
    expect(pq.top.freq).to eq(2)

    pq.insert('4',4)
    pq.insert('1',1)
    expect(pq.top.freq).to eq(4)
  end
  
  #      6
  #   4     5
  #  1 2   3
  # direct_bypass -  6 4 1 2 5 3
  it "direct_bypass" do
    expect(pq.direct_bypass).to eq([])
    expect(Pq::direct_bypass(pq)).to eq([])

    node3 = Node.new('3',3, nil, nil)
    node5 = Node.new('5',5, node3, nil)

    node1 = Node.new('1',1, nil, nil)
    node2 = Node.new('2',2, nil, nil)
    node4 = Node.new('4',4, node1, node2)

    pq.insert('6',6, node4, node5)
    
    nodes = [['6',6], ['4',4], ['1',1], ['2',2], ['5',5], ['3',3]]
    expect(pq.direct_bypass).to eq(nodes)
    expect(Pq::direct_bypass(pq)).to eq(nodes)
  end

  #   4          5
  #  1 2  merge 3 
  it "#merge!" do
    pq.insert('1',1)
    pq.insert('2',2)
    pq.insert('4',4)
    
    pq2 = Pq.new
    pq2.insert('3',3)
    pq2.insert('5',5)

    expect(pq.merge!(pq2).direct_bypass).to eq([["5", 5], ["4", 4], ["2", 2], ["1", 1], ["3", 3]])
  end

  it "#del_top" do
    pq.insert('1',1)
    pq.insert('2',2)
    pq.insert('3',3)
    
    3.downto(1) do |i|
      expect(pq.del_top.freq).to eq(i)
    end
    expect(pq.del_top).to eq(nil)
  end

end