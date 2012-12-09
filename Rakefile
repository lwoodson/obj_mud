task :default => [:test]

task :console do
  load_env
  start_irb
end

task :obj_mud_console do
  load_env

  loc1 = ObjMud::Model::Location.new("loc1")
  loc2 = ObjMud::Model::Location.new("loc2")
  loc1.paths << ObjMud::Model::Path.new(loc2)
  viewer = ObjMud::Model::Viewer.new(loc1)
  loc2.paths << ObjMud::Model::Path.new(loc1)

  controller = ObjMud::Controller.new
  controller.config = ObjMud::Config.instance
  controller.viewer = viewer
  viewer.add_observer(controller)
  controller.start
end

task :test do
  raise "Write some tests, Dammit!"
end

private
def load_env
  $: << File.join('.', 'lib')
  require 'obj_mud'
end

def start_irb
  require 'irb'
  ARGV.clear
  IRB.start 
end
