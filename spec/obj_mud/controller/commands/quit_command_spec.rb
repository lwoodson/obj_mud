require 'spec_helper'
require 'obj_mud/controller'
require 'obj_mud/controller/commands/common_command_spec'

include CommonCommandSpecs

describe ObjMud::Controller::Commands::QuitCommand do
  it "should indicate that it maps to :exit and :quit input" do
    ObjMud::Controller::Commands::QuitCommand.for_command_inputs.should eq([:exit, :quit])
  end

  it "should register itself as a command with ObjMud::Controller::Commands" do
    ensure_registered(ObjMud::Controller::Commands::QuitCommand)
  end

  it "should tell the controller to exit when performed" do
    controller = ObjMud::Controller::Impl.new
    command = ObjMud::Controller::Commands::QuitCommand.new
    command.controller = controller
    controller.expects(:display_output).with(command.goodbye_msg)
    controller.expects(:exiting=).with(true)
    command.perform(nil)
  end
end
