require 'observer'

require 'obj_mud/config'
require 'obj_mud/events'

module ObjMud
  module Model
    class Viewer
      include Observable
      include ConfigDependent

      attr_accessor :location

      def initialize(location=nil)
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
      attr_accessor :object, :paths

      def initialize(obj=nil)
        @object = obj
        @paths = []
        location_initializer().call(self)
      end
    end

    class Path
      attr_accessor :name, :object
      def initialize(name=nil, obj=nil)
        @name = name
        @object = obj
      end
    end
  end
end
