# ObjMud #
ObjMud is a framework to provide a text-based adventure game interface into a 
business model.  It is geeky as all get out.  Its genesis was to support the
Zormk gem, which provides a Zork-like interface into ActiveRecord (and
potentially other ORM) models.  Beyond being an extremely geeky exercise in
mental masturbation, it has helped me be able to understand the domain model
in a complicated enterprisy rails application (400+ models, some with like 12
mixins, etc...).

## How it Works ##
The user enters the ObjMud environment at a location, which is bound to a
business object.  The viewer is presented with a text rendering of the business
object at their current location.  The viewer uses a move command to navigate the
graph of locations and paths.  The viewer can terminate the session with a quit
command.

## Demo Session ##
`rake demo` will start a demo session of the interface from the command line
terminal. The business object graph are of Persons that have relationships to
other Persons.  There are 3 persons in the graph.  Dick, Jane and Bob, each
with relationships between them.  You can test out an ObjMud session as
follows:

```
> rake demo
Welcome!  The minions of your project grow stronger...
[Dick(relatives: Jane, Joe)]
  Paths: Jane(relatives: Dick, Joe), Joe(relatives: Dick, Jane)

> help
Available commands: back, exit, go, help, look, ls, move, quit

> look /paths/i
  Paths: Jane(relatives: Dick, Joe), Joe(relatives: Dick, Jane)

> go jane
You move to Jane(relatives: Dick, Joe)...

[Jane(relatives: Dick, Joe)]
  Paths: Dick(relatives: Jane, Joe), Joe(relatives: Dick, Jane)

> go joe
You move to Joe(relatives: Dick, Jane)...

[Joe(relatives: Dick, Jane)]
  Paths: Dick(relatives: Jane, Joe), Jane(relatives: Dick, Joe)

> back
You move to Jane(relatives: Dick, Joe)...

[Jane(relatives: Dick, Joe)]
  Paths: Dick(relatives: Jane, Joe), Joe(relatives: Dick, Jane)

> exit
Goodbye!  The minions of your project grow weaker...
>
```

## Configuration ##
Configuration is done via an ObjMud.configure call.  If part of a rails
application, this should go in an initializer.  Here is the default values and
comments for each of the configuration options.

* `config.location_initializer`: locations are lazily iniatized whenever a user 
enters obj_mud, or moves down a path.  This callback allows you to initialize 
the business object of a location as appropriate to your use.  By default, it 
does nothing.
* `config.renderer`:  What will render business objects to the 
viewer.  The default renderer output can be seen in the demo.
* `config.path_detected`: Callable that accepts a user input and a path and 
returns true if the input identifies the path or false otherwise.  By default, 
if the input string matches the path's object (ignoring case), then this returns
true.
* `config.hello_msg`: A message to display to users when they enter obj mud
* `config.goodby_msg`:  A message to display to users when they leave the obj
mud

In practive, you will probably need to provide a location_initializer, renderer
and path_detected callable appropriate to your context.

The configuration object passed to the block given the configure call is backed
by OpenStruct, so you are free to stick whatever other information you need
into the config to allow any further customizations to do their job.

```ruby
ObjMud.configure do |config|
  config.location_initializer = lambda {|location| do_something}
  config.renderer = MyRenderer
  config.path_detected = lambda {|input, path| do_something_else}
  config.arbitrary_config_value = "Foo"
end
```

## Commands ##
Commands are actions that the user can perform.  They should probably inherit
from ObjMud::Controller::Base which will give access to the controller invoking
the command (which gives access to everything else) and configuration values.

There are 3 hard requirements of command classes:
1. It implements a `for_command_inputs` class method that returns an array of
symbols that user input should match to invoke the command.
2. It implements a perform instance mthod that executes the command.
3. It registers itself with the Commands module via
`ObjMud::Controller::Commands.register(self)`

Here is an example command definition:

```ruby
class DanceCommand < ObjMud::Controller::Commands::Base
  def self.for_command_inputs
    [:dance]
  end

  def perform(*tokens)
    controller.display_output("You dance around")
  end

  ObjMud::Controller::Commands.register(self)
end
```

