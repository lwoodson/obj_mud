task :default => [:test]

desc "Invokes all spec tests"
task :test do
  puts `rspec`
end

desc "Runs a small demo of obj_mud navigating people and their relatives."
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
        location.paths << ObjMud::Model::Path.new(relative.name, relative)
      end
    end
  end

  ObjMud.start(dick)
end

desc "builds the gem"
task :build do
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
