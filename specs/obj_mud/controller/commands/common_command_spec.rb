#require_relative File.join('..','..','..','spec_helper')

module CommonCommandSpecs
  def ensure_registered(clazz)
    clazz.for_command_inputs.each do |input|
      ObjMud::Controller::Commands.find(input).should == clazz
    end
  end
end
