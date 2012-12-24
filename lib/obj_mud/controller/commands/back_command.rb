require 'obj_mud/controller/commands'

module ObjMud
  module Controller
    module Commands
      class BackCommand < Base
        def self.for_command_inputs
          [:back]
        end
        
        def perform(*tokens)
          raise "You haven't been anywhere yet" if controller.viewer.last_location.nil?
          controller.viewer.move_to_location(controller.viewer.last_location)
        end

        ObjMud::Controller::Commands.register(self)
      end
    end
  end
end
