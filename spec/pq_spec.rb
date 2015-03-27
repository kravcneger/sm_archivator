require 'spec_helper'

RSpec.describe Pq do
  let(:pq){ Pq.new }
  
  it "#del_min" do
    expect(pq.del_min).to eq(nil)
    pq.insert('2',2)
    pq.insert('4',4)
    pq.insert('1',1)

    expect(pq.del_min.freq).to eq(1)
    expect(pq.del_min.freq).to eq(2)
  end

  it "#size and #insert" do
    expect{pq.insert('2',2);pq.insert('4',4)}.to change{pq.size}.from(0).to(2)
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

end