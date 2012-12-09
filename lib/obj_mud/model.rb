require 'observer'

require 'obj_mud/events'

module ObjMud
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
    end

    class Path
      attr_reader :location
      def initialize(location)
        @location = location
      end
    end
  end
end
