require 'stringio'

require_relative File.join('..', 'spec_helper')

require 'obj_mud/controller'
require 'obj_mud/events'

describe ObjMud::Controller::Impl do
  before :each do
    $stdout = StringIO.new
    @controller = ObjMud::Controller.new
  end

  it "should send messages to $stdout when display_output invoked" do
    @controller.display_output('test')
    $stdout.rewind
    $stdout.read.should eq("test\n")
  end

  it "should should correctly respond to user input." do
    $stdin = StringIO.new("help\n\nfoobar\nexit\n")
    @controller.collect_input
    $stdout.rewind
    $stdout.read.should eq("\n> Available commands: exit, go, help, look, ls, move, quit\n" + \
                           "\n> I don't understand.  Type 'help' for available commands.\n" + \
                           "\n> I don't understand.  Type 'help' for available commands.\n" + \
                           "\n> Goodbye!  The minions of your project grow weaker...\n")
  end

  context "when receiving MovedLocation events" do
    before :each do
      @evt = ObjMud::Events::MovedLocation.new 'viewer', 'old_loc', 'new_loc' 
    end

    it "should invoke moved_location" do
      @controller.expects(:moved_location).with(@evt)
      @controller.update(@evt)
    end

    it "should render the event and the description of the new location" do
      @controller.renderer.expects(:render_moved_location).with('viewer', 'old_loc', 'new_loc').returns('leaving old_loc...')
      @controller.renderer.expects(:render_location).with('new_loc').returns('new_loc')
      @controller.moved_location(@evt)
      $stdout.rewind
      $stdout.read.should eq("leaving old_loc...\n\nnew_loc\n")
    end
  end
end
