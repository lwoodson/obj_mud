require 'spec_helper'
require 'obj_mud/controller'
require 'obj_mud/controller/commands/common_command_spec'

include CommonCommandSpecs

describe ObjMud::Controller::Commands::BackCommand do
  it "should indicate that it maps to :back input" do
    ObjMud::Controller::Commands::BackCommand.for_command_inputs.should eq([:back])
  end

  it "should register itself as a command with ObjMud::Controller::Commands" do
    ensure_registered(ObjMud::Controller::Commands::BackCommand)
  end

  context "when performing command" do
    before :each do
      @viewer = FactoryGirl.create :viewer
      @controller = ObjMud::Controller.new
      @controller.viewer = @viewer
      subject.controller = @controller
    end
    
    it "should move the viewer to the last location if one exists" do
      @last_location = FactoryGirl.create :location
      @viewer.last_location = @last_location
      subject.perform(nil)
      @viewer.location.should eq(@last_location)
    end

    it "should not move the viewer and raise exception if there is no last location" do
      expect {subject.perform(nil)}.to raise_error("You haven't been anywhere yet")
    end
  end
end
