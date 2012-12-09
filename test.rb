$: << './lib'
require 'obj_mud'

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

