require 'obj_mud/controller/commands'

module ObjMud
  module Controller
    module Commands
      class HelpCommand < Base
        def self.for_command_inputs
          [:help]
        end

        def perform(tokens)
          command_inputs = ObjMud::Controller::Commands.inputs.join(", ")
          controller.display_output "Available commands: #{command_inputs}"
        end

        ObjMud::Controller::Commands.register(self)
      end
    end
  end
end
