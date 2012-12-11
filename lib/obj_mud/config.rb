require 'singleton'
require 'ostruct'

module ObjMud
  def self.configure(&block)
    block.call(ObjMud::Config.instance)
  end

  class Config
    include Singleton

    def initialize
      @open_config = OpenStruct.new
      @open_config.location_initializer = lambda {|location| }
      @open_config.renderer = ObjMud::View::DefaultRenderer.new
      @open_config.path_detected = lambda {|input, path| path.name.to_s.downcase == input.to_s.downcase}
      @open_config.hello_msg = "Welcome!  The minions of your project grow stronger...\n"
      @open_config.goodbye_msg = "Goodbye!  The minions of your project grow weaker...\n"
    end

    def method_missing(method, *args)
      @open_config.send(method.to_sym, *args)
    end
  end

  module ConfigDependent
    def method_missing(method_name, *args)
      config.send(method_name.to_sym, *args)
    end

    def config
      Config.instance
    end
  end
end
