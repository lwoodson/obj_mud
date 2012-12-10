task :default => [:test]

task :console do
  load_env
  start_irb
end

task :demo do
  class Person
    attr_reader :name, :relatives

    def initialize(name)
      @name = name
      @relatives = []
    end

    def to_s
      "#{name}(relatives: #{relatives.map{|r| r.name}.join(", ")})"
    end
  end

  load_env
  dick = Person.new("Dick")
  jane = Person.new("Jane")
  joe = Person.new("Joe")
  dick.relatives << jane
  dick.relatives << joe
  jane.relatives << dick
  jane.relatives << joe
  joe.relatives << dick
  joe.relatives << jane

  ObjMud.configure do |config|
    config.location_initializer = lambda do |location| 
      location.object.relatives.each do |relative|
        location.paths << ObjMud::Model::Path.new(relative)
      end
    end

    config.path_detected = lambda {|input, path| path.object.name.downcase == input.downcase}
  end

  ObjMud.start(dick)
end

task :test do
  raise "Write some tests, Dammit!"
end

task :build_gem do
  puts `gem build obj_mud.gemspec`
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
