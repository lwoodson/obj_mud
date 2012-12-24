require 'spec_helper'
require 'obj_mud/controller'
require 'obj_mud/controller/commands/common_command_spec'

include CommonCommandSpecs

describe ObjMud::Controller::Commands::MoveCommand do
  it "should indicate that it maps to go and move input" do
    ObjMud::Controller::Commands::MoveCommand.for_command_inputs.should eq([:go, :move])
  end

  it "should register itself as a command with ObjMud::Controller::Commands" do
    ensure_registered(ObjMud::Controller::Commands::MoveCommand)
  end

  context "when performing command" do
    before :each do
      @viewer = FactoryGirl.create :viewer
      @controller = ObjMud::Controller.new
      @controller.viewer = @viewer
      subject.controller = @controller
    end

    it "should move the viewer to the new location if path is found" do
      path = @viewer.location.paths.first
      subject.expects(:path_detected).returns(lambda {|input, path| true})
      @viewer.expects(:move).with(path)
      subject.perform(path.object)
    end

    it "should not move the viewer and raise an exception if path is not found" do
      subject.expects(:path_detected).returns(lambda {|input, path| false}).at_least_once
      expect {subject.perform("foo")}.to raise_error("foo is not a valid destination")  
    end
  end
end
