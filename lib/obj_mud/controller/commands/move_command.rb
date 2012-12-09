require 'obj_mud/controller/commands'

module ObjMud
  module Controller
    module Commands
      class MoveCommand < Base
        def self.for_command_inputs
          [:go, :move]
        end

        def perform(input, *other_args)
          destination = nil
          controller.viewer.location.paths.each do |path|
            if path_detected.call(input, path)
              destination = path.location
            end
          end
          raise "#{input} is not a valid destination" if destination.nil?
          controller.viewer.move(destination)
        end

        ObjMud::Controller::Commands.register(self)
      end
    end
  end
end


