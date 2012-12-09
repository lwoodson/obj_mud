require 'observer'
require 'singleton'

module ObjMud
  class Config
    include Singleton
    attr_accessor :renderer, :path_detected, :hello_msg, :goodbye_msg
    # TODO delegator to an openstruct for anything not defined here.
    # Will allow for arbitrary configuration for any commands defined
    # outside of the default set.

    def initialize
      @renderer = ObjMud::View::DefaultRenderer.new
      @path_detected = lambda {|input, path| path.location.object == input}
      @hello_msg = "Welcome!  The minions of #{__FILE__} grow stronger...\n"
      @goodbye_msg = "Goodbye!  The minions of #{__FILE__} grow weaker...\n"
    end

    def self.init(&block)
      block.call(self.instance)
    end
  end

  module ConfigDependent
    attr_accessor :config

    def method_missing(method_name, *args)
      config.send(method_name.to_sym, *args)
    end
  end
 
  module Events
    MovedLocation = Struct.new :viewer, :old_location, :new_location do
      def type
        :moved_location
      end
    end
  end
  
  module Model
    # TODO something to create the model each step of the way.
    # Basically, the exits need to be recreated whenever the
    # viewer moves between locations.
    class Viewer
      include Observable
      attr_reader :location

      def initialize(location)
        @location = location
      end

      def move(new_location)
        old_location = @location
        @location = new_location
        changed
        evt = ObjMud::Events::MovedLocation.new self, old_location, new_location
        notify_observers(evt)
      end
    end

    class Location
      attr_reader :object, :paths

      def initialize(obj=nil)
        @object = obj
        @paths = []
      end

      def to_s
      end
    end

    class Path
      attr_reader :location
      def initialize(location)
        @location = location
      end
    end
  end

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
        STDOUT.write("\n> ")
        ARGF.each do |line|
          begin
            command_str, *args = line.split
            raise "I don't understand.  Type 'help for available commands." if command_str.nil?
            command_class = ObjMud::Controller::Command.find(command_str.to_sym)
            raise "I don't understand.  Type 'help' for available commands." if command_class.nil?
            command = command_class.new
            command.controller = self
            command.config = config
            command.perform(args.join(" "))
          rescue StandardError => e
            display_output(e)
          end
          if exiting?
            break
          else
            STDOUT.write("\n> ")
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
        display_output(renderer.render_location(viewer.location))
      end
    end

    module Command
      @command_map = {}

      def self.register(command_class)
        command_class.send(:for_command_inputs).each do |command_input|
          @command_map[command_input] = command_class
        end
      end

      def self.inputs
        @command_map.keys.sort
      end

      def self.find(key)
        @command_map[key]
      end

      class Base
        include ConfigDependent
        attr_accessor :controller
      end

      class LookCommand < Base
        def self.for_command_inputs
          [:look, :ls]
        end

        def perform(tokens)
          controller.display_output(renderer.render_location(controller.viewer.location))
        end

        ObjMud::Controller::Command.register(self)
      end

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

        ObjMud::Controller::Command.register(self)
      end

      class QuitCommand < Base
        def self.for_command_inputs
          [:exit, :quit]
        end

        def perform(tokens)
          controller.display_output goodbye_msg
          controller.renderer
          controller.exiting = true
        end

        ObjMud::Controller::Command.register(self)
      end

      class HelpCommand < Base
        def self.for_command_inputs
          [:help]
        end

        def perform(tokens)
          command_inputs = ObjMud::Controller::Command.inputs.join(", ")
          controller.display_output "Available commands: #{command_inputs}"
        end

        ObjMud::Controller::Command.register(self)
      end
    end
  end

  module View
    class DefaultRenderer
      def render_location(location)
        "[#{location.object}]\n  Paths: #{location.paths.map{|path| render_path(path)}.join(',')}"
      end

      def render_path(path)
        "#{path.location.object}"
      end

      # render events.
      def render_moved_location(viewer, old_loc, new_loc)
        "You move to #{new_loc.object}..."
      end
    end
  end
end

loc1 = ObjMud::Model::Location.new("loc1")
loc2 = ObjMud::Model::Location.new("loc2")
loc1.paths << ObjMud::Model::Path.new(loc2)
viewer = ObjMud::Model::Viewer.new(loc1)
loc2.paths << ObjMud::Model::Path.new(loc1)

controller = ObjMud::Controller.new
controller.config = ObjMud::Config.instance
controller.viewer = viewer
#controller.renderer = ObjMud::Config.instance.renderer
viewer.add_observer(controller)
#viewer.move(loc2)
controller.start
