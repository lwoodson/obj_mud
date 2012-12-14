require 'obj_mud/controller/commands'

module ObjMud
  module Controller
    module Commands
      class LookCommand < Base
        def self.for_command_inputs
          [:look, :ls]
        end

        def perform(filter, *other_tokens)
          output = renderer.render_location(controller.viewer.location)
          begin
            unless filter.nil? or filter.empty?
              output = output.split("\n").grep(eval(filter)).join("\n")
            end
          rescue SyntaxError => e
            raise "Could not eval #{filter}"
          end
          controller.display_output(output)
        end

        ObjMud::Controller::Commands.register(self)
      end
    end
  end
end
