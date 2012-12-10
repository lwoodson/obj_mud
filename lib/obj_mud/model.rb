require 'observer'

require 'obj_mud/config'
require 'obj_mud/events'

module ObjMud
  module Model
    # TODO something to create the model each step of the way.
    # Basically, the exits need to be recreated whenever the
    # viewer moves between locations.
    class Viewer
      include Observable
      include ConfigDependent

      attr_reader :location

      def initialize(location)
        @location = location
      end

      def move(path)
        old_location = @location
        @location = Location.new(path.object)
        changed
        evt = ObjMud::Events::MovedLocation.new self, old_location, @location
        notify_observers(evt)
      end
    end

    class Location
      include ConfigDependent
      attr_reader :object, :paths

      def initialize(obj)
        @object = obj
        @paths = []
        location_initializer().call(self)
      end
    end

    class Path
      attr_reader :name, :object
      def initialize(name, obj)
        @name = name
        @object = obj
      end
    end
  end
end
