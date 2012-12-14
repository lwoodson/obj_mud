require_relative File.join('..','spec_helper')

require 'obj_mud/config'
require 'obj_mud/model'

describe ObjMud::Model::Location do
  it "should allow access to business object" do
    ObjMud::Model::Location.new('business_obj').object.should eq('business_obj')
  end

  it "should initialize empty paths array on instantiation" do
    ObjMud::Model::Location.new('business_obj').paths.should eq([])
  end

  it "should invoke configured location_initializer" do
    invoked = false
    ObjMud::Config.instance.location_initializer = lambda{|loc| invoked = true}
    ObjMud::Model::Location.new('business_obj')
    invoked.should eq(true)
  end
end

describe ObjMud::Model::Path do

end

describe ObjMud::Model::Viewer do
  before :each do
    @current_loc = ObjMud::Model::Location.new("current_location")
    @path = ObjMud::Model::Path.new(:up, "next_location")
    @viewer = ObjMud::Model::Viewer.new(@current_loc)
  end

  it "should change locations on call to move" do
    @viewer.move(@path)
    @viewer.location.object.should eq("next_location")
  end

  it "should notify observers of location change on call to move" do
    notified = false
    self.class.send(:define_method, :update) do |evt, *other_args|
      notified = true
      evt.viewer.should eq(@viewer)
      evt.old_location.should eq(@current_loc)
      evt.new_location.should be_a_kind_of(ObjMud::Model::Location)
    end
    @viewer.add_observer(self)
    @viewer.move(@path)
    notified.should eq(true)
  end
end
