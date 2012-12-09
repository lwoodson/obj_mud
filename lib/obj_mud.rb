require 'obj_mud/config'
require 'obj_mud/model'
require 'obj_mud/view'
require 'obj_mud/controller'
require 'obj_mud/controller/commands'

default_command_path = File.join(File.dirname(__FILE__), 'obj_mud', 'controller', 'commands')
Dir.entries(default_command_path).grep(/.+\.rb/).each do |command_file|
  name, ext = command_file.split(".")
  require "obj_mud/controller/commands/#{name}"
end
