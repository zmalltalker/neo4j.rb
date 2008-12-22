$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../lib")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/..")

require 'neo4j'
require 'neo4j/spec_helper'



describe 'Neo4j::Node cluster' do
  before(:all) do
    start
    class ClusterNode
      include Neo4j::NodeMixin
      property :foo, :bar
    end
  end

  after(:all) do
    stop
  end

  it "should print events" do
    c = ClusterNode.new
    c.foo = 2
  end
end