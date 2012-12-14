require_relative 'spec_helper'

require 'obj_mud'

describe ObjMud do
  it "should start an interactive session when start is called" do
    $stdin = StringIO.new("exit\n")
    output = StringIO.new()
    $stdout = output
    ObjMud.start('test')
    $stdout.rewind
    $stdout.read.should eq("Welcome!  The minions of your project grow stronger...\n" + \
                           "[test]\n  Paths: \n\n> Goodbye!  The minions of your project grow weaker...\n")
  end
end
