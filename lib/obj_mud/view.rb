module ObjMud
  module View
    class DefaultRenderer
      def render_location(location)
        "[#{location.object}]\n  Paths: #{location.paths.map{|path| path.object}.join(', ')}"
      end

      def render_moved_location(viewer, old_loc, new_loc)
        "You move to #{new_loc.object}..."
      end
    end
  end
end
