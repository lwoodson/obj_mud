module ObjMud
  module Events
    MovedLocation = Struct.new :viewer, :old_location, :new_location do
      def type
        :moved_location
      end
    end
  end
end
