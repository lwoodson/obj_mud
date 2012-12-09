require 'singleton'

module ObjMud
  class Config
    include Singleton
    attr_accessor :renderer, :path_detected, :hello_msg, :goodbye_msg
    # TODO delegator to an openstruct for anything not defined here.
    # Will allow for arbitrary configuration for any commands defined
    # outside of the default set.

    def initialize
      @renderer = ObjMud::View::DefaultRenderer.new
      @path_detected = lambda {|input, path| path.location.object == input}
      @hello_msg = "Welcome!  The minions of #{__FILE__} grow stronger...\n"
      @goodbye_msg = "Goodbye!  The minions of #{__FILE__} grow weaker...\n"
    end

    def self.init(&block)
      block.call(self.instance)
    end
  end

  module ConfigDependent
    attr_accessor :config

    def method_missing(method_name, *args)
      config.send(method_name.to_sym, *args)
    end
  end
end
