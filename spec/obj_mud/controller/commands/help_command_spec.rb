require_relative File.join('..','..','..','spec_helper')
require_relative 'common_command_spec'
require 'obj_mud/controller'
require 'obj_mud/controller/commands/help_command'

include CommonCommandSpecs

describe ObjMud::Controller::Commands::HelpCommand do
  it "should indicate that it maps to :help input" do
    ObjMud::Controller::Commands::HelpCommand.for_command_inputs.should == [:help]
  end


  it "should register itself as a command ith ObjMud::Controller::Commands" do
    ensure_registered(ObjMud::Controller::Commands::HelpCommand)
  end

  it "should display list of commands when performed" do
    controller = ObjMud::Controller.new
    command = ObjMud::Controller::Commands::HelpCommand.new
    command.controller = controller
    expected = "Available commands: #{ObjMud::Controller::Commands.inputs.join(', ')}"
    controller.expects(:display_output).with(expected)
    command.perform(nil)
  end
end
