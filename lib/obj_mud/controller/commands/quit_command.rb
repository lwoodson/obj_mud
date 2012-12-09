require 'obj_mud/controller/commands'

module ObjMud
  module Controller
    module Commands
      class QuitCommand < Base
        def self.for_command_inputs
          [:exit, :quit]
        end

        def perform(tokens)
          controller.display_output goodbye_msg
          controller.renderer
          controller.exiting = true
        end

        ObjMud::Controller::Commands.register(self)
      end

    end
  end
end
