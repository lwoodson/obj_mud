require_relative File.join('..','spec_helper')
require 'obj_mud/config'
require 'obj_mud/model'

describe ObjMud::Config do
  before :each do
    @config = ObjMud::Config.instance
  end

  it "should have default value for location_initializer" do
    @config.location_initializer.should_not eq(nil)
  end

  it "should have DefaultRenderer as its renderer" do
    @config.renderer.class.should == ObjMud::View::DefaultRenderer
  end

  it "should have a default hello_msg" do
    @config.hello_msg.empty?.should_not eq(true)
  end

  it "should have a default goodbye_msg" do
    @config.goodbye_msg.empty?.should_not eq(true)
  end

  context "default path_detected callable" do
    before :each do
      @path_detected = @config.path_detected 
      @path = ObjMud::Model::Path.new('test',nil)
    end

    it "should not be nil" do
      @path_detected.should_not eq(nil)
    end

    it "should match input regardless of case" do
      @path_detected.call('TEST',@path).should eq(true)
      @path_detected.call('test',@path).should eq(true)
    end

    it "should not match incorrect input" do
      @path_detected.call('foo',@path).should_not eq(true)
    end
  end

  it "should be open and allow aribtrary configuration values usable by implementations" do
    @config.foo = 1
    @config.foo.should eq(1)
  end

  it "should allow custom configuration via ObjMud.configure call" do
    ObjMud.configure do |config|
      config.hello_message = "Aloha means goodbye"
    end
    @config.hello_message.should eq("Aloha means goodbye")
  end
end

describe ObjMud::ConfigDependent do
  before :each do
    class TestConfigDependent
      include ObjMud::ConfigDependent
      def renderer
        puts "no config for joo"
      end
    end
    @config_dependent = TestConfigDependent.new
  end

  it "should allow direct access to ObjMud::Config instance via config method" do
    @config_dependent.config.should eq(ObjMud::Config.instance)
  end

  it "should directly forward calls to methods not defined in class to ObjMud::Config instance" do
    @config_dependent.location_initializer.should eq(ObjMud::Config.instance.location_initializer)
  end

  it "should not forward calls to methods defined in the class to ObjMud::Config instance" do
    @config_dependent.renderer.should_not eq(ObjMud::Config.instance.renderer)
  end
end
