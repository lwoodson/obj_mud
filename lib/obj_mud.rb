require 'obj_mud/config'
require 'obj_mud/model'
require 'obj_mud/view'
require 'obj_mud/controller'
require 'obj_mud/controller/commands'

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
