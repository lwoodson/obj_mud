require 'obj_mud/controller/commands'

module ObjMud
  module Controller
    module Commands
      class LookCommand < Base
        def self.for_command_inputs
          [:look, :ls]
        end

        def perform(tokens)
          controller.display_output(renderer.render_location(controller.viewer.location))
        end

        ObjMud::Controller::Commands.register(self)
      end
    end
  end
end
