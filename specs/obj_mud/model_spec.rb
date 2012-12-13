require_relative File.join('..','spec_helper')

require 'obj_mud/model'

describe ObjMud::Model::Location do
 before :each do
   @location = ObjMud::Model::Location.new('business_obj')
 end

 it "should allow access to business object" do
   @location.object.should eq('business_obj')
 end

 it "should initialize empty paths array on instantiation" do
   @location.paths.should eq([])
 end
end

describe ObjMud::Model::Path do
  
end

describe ObjMud::Model::Viewer do
  
end
