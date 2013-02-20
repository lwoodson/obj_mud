require 'obj_mud/config'
require 'obj_mud/model'
require 'obj_mud/view'
require 'obj_mud/controller/commands'

module ObjMud
  module Controller
    def self.new
      return Impl.new
    end

    class Impl
      include ConfigDependent
      attr_accessor :viewer, :exiting
      alias :exiting? :exiting

      def initialize
        @exiting = false
      end

      def start
        display_output hello_msg
        display_output(renderer.render_location(viewer.location))
        collect_input
      end

      def collect_input
        $stdout.write("\n> ")
        $stdin.each do |line|
          begin
            command_str, *args = line.split
            raise "I don't understand.  Type 'help' for available commands." if command_str.nil?
            command_class = ObjMud::Controller::Commands.find(command_str.to_sym)
            raise "I don't understand.  Type 'help' for available commands." if command_class.nil?
            command = command_class.new
            command.controller = self
            command.perform(args.join(" "))
          rescue StandardError => e
            display_output(e)
          end
          if exiting?
            break
          else
            $stdout.write("\n> ")
          end
        end
      end

      def display_output(output)
        puts(output)
      end

      def update(evt)
        self.send(evt.type, evt)
      end

      def moved_location(evt)
        display_output(renderer.render_moved_location(evt.viewer, evt.old_location, evt.new_location))
        display_output("\n")
        display_output(renderer.render_location(evt.new_location))
      end
    end

  end
end
