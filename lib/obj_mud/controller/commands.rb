require 'obj_mud/config'

module ObjMud
  module Controller
    module Commands
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
    end
  end
end
