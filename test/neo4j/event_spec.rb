$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../lib")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/..")

require 'neo4j'
require 'neo4j/spec_helper'


include Neo4j



describe "Event" do

  it "should match event of correct type and property value" do
    e = Neo4j::PropertyChangedEvent.new("some_node", "age", "29", "30")
    Neo4j::PropertyChangedEvent.trigger?(e, :property, :age).should be_true
  end

  it "should match event of correct inherited type" do
    Neo4j::Event.trigger?(Neo4j::PropertyChangedEvent.new("some_node", "age", "29", "30")).should be_true
    Neo4j::PropertyChangedEvent.trigger?(Neo4j::Event.new(nil),:property, :age).should be_false
  end
  
  
  it "should not match event of correct type and incorrect property value" do
    e = Neo4j::PropertyChangedEvent.new("some_node", "age", "29", "30")
    Neo4j::PropertyChangedEvent.trigger?(e, :property, :name).should be_false
  end
  
  it "should not match event of correct type and correct property value and incorrect property name" do
    e = Neo4j::PropertyChangedEvent.new("some_node", "age", "29", "30")
    Neo4j::PropertyChangedEvent.trigger?(e, :relation, :name).should be_false
  end
  
  it "should match event of incorrect correct type and incorrect property value" do
    e = Neo4j::PropertyChangedEvent.new("some_node", "age", "29", "30")
    Neo4j::RelationshipAddedEvent.trigger?(e).should be_false
  end

end


describe "Event replicated" do
  before(:each) do
    start
    undefine_class :Person
    class Person
      include Neo4j::NodeMixin
      property :age
    end
    Neo4j::Config[:cluster_master] = true
  end
  after(:each) do
    stop
  end
  
  it "should create a new node on Neo4j::NodeCreatedEvent" do
    pending
    node = mock('Node')
    node.stub!(:neo_node_id).and_return("1")
    node.stub!(:class).and_return(Person)
    
    event = Neo4j::NodeCreatedEvent.new(node)
    k = eval(event.replicate)
    k.should be_instance_of(Person)
  end

  it "should create a new node on Neo4j::NodeCreatedEvent" do
    person = Person.new
    event = Neo4j::PropertyChangedEvent.new(person, :age, "10", "11")
    k = eval(event.replicate)
    k.should be_instance_of(Person)
    k.age.should == "11"
    puts k, k.class.to_s, k.neo_node_id
  end

end