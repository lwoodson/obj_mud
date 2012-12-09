Gem::Specification.new do |s|
  s.name  = 'obj_mud'
  s.version  = '0.0.1'
  s.date  = '2012-12-08'
  s.summary  = 'Text-based adventure gamish navigation of objects.'
  s.description  = s.summary
  s.authors     = ['Lance Woodson']
  s.email  = 'lance@webmaneuvers.com'
  s.files  = [
    "lib/obj_mud.rb",
    "lib/obj_mud/config.rb",
    "lib/obj_mud/controller.rb",
    "lib/obj_mud/events.rb",
    "lib/obj_mud/model.rb",
    "lib/obj_mud/view.rb",
    "lib/obj_mud/controller/commands.rb",
    "lib/obj_mud/controller/commands/help_command.rb",
    "lib/obj_mud/controller/commands/look_command.rb",
    "lib/obj_mud/controller/commands/move_command.rb",
    "lib/obj_mud/controller/commands/quit_command.rb"
  ] 
  s.homepage  = 'https://github.com/lwoodson/obj_mud/'
end

