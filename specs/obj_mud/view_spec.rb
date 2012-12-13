require_relative File.join('..', 'spec_helper')
require 'obj_mud/view'
require 'obj_mud/model'

describe ObjMud::View::DefaultRenderer do
  before :each do
    @renderer = ObjMud::View::DefaultRenderer.new
    @loc = ObjMud::Model::Location.new('location')
    @path1 = ObjMud::Model::Path.new(:path1, 'path1')
    @loc.paths << @path1
    @path2 = ObjMud::Model::Path.new(:path2, 'path2')
    @loc.paths << @path2
  end

  it "should render a location using its paths and associated business objects" do
     expected = "[#{@loc.object}]\n  Paths: #{@path1.object}, #{@path2.object}"
     @renderer.render_location(@loc).should eq(expected)
  end

  it "should render the moved_location event" do
    @renderer.render_moved_location(nil, nil, @loc).should eq("You move to location...")
  end
end
