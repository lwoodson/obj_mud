module ObjMud
  module View
    class DefaultRenderer
      def render_location(location)
        "[#{location.object}]\n  Paths: #{location.paths.map{|path| render_path(path)}.join(',')}"
      end

      def render_path(path)
        "#{path.location.object}"
      end

      def render_moved_location(viewer, old_loc, new_loc)
        "You move to #{new_loc.object}..."
      end
    end
  end
end
