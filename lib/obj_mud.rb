require 'obj_mud/config'
require 'obj_mud/model'
require 'obj_mud/view'
require 'obj_mud/controller'
require 'obj_mud/controller/commands'

default_command_path = File.join(File.dirname(__FILE__), 'obj_mud', 'controller', 'commands')
Dir.entries(default_command_path).grep(/.+\.rb/).each do |command_file|
  name, ext = command_file.split(".")
  require "obj_mud/controller/commands/#{name}" if not name.nil? and not name.empty?
end

module ObjMud
  extend ObjMud::ConfigDependent

  def self.start(business_object)
    location = ObjMud::Model::Location.new(business_object)
    viewer = ObjMud::Model::Viewer.new(location)
    controller = ObjMud::Controller.new
    controller.viewer = viewer
    viewer.add_observer(controller)
    controller.start
  end
end
