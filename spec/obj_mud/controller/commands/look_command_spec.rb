require_relative File.join('..','..','..','spec_helper')
require_relative 'common_command_spec'
require 'obj_mud/controller'
require 'obj_mud/model'

include CommonCommandSpecs

describe ObjMud::Controller::Commands::LookCommand do
  it "should indicate that it maps to :look and :ls" do
    ObjMud::Controller::Commands::LookCommand.for_command_inputs.should eq([:look, :ls])
  end

  it "should register itself as a command with ObjMud::Controller::Commands" do
    ensure_registered(ObjMud::Controller::Commands::LookCommand) 
  end

  context "when being performed" do
    before :each do
      @command = ObjMud::Controller::Commands::LookCommand.new
      @controller = ObjMud::Controller.new
      @location = ObjMud::Model::Location.new('test')
      @viewer = ObjMud::Model::Viewer.new(@location)
      @controller.viewer = @viewer
      @command.controller = @controller
    end

    it "should display rendered location when invoked with no args" do
      @command.renderer.expects(:render_location).with(@location).returns('foo')
      @controller.expects(:display_output).with("foo")
      @command.perform(nil)
    end

    it "should display rendered location matching regex with regex arg" do
      @command.renderer.expects(:render_location).with(@location).returns("foo\nbar")
      @controller.expects(:display_output).with("bar")
      @command.perform("/bar/")
    end

    it "it should raise evaluation RuntimeError when it cannot eval the filter" do
      @command.renderer.expects(:render_location).with(@location).returns("foo\nbar")
      expect{@command.perform("/bar")}.to raise_error(RuntimeError)
    end
  end
end
