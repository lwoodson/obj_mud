require 'factory_girl'
require 'obj_mud/model'

FactoryGirl.define do
  factory :path, :class => ObjMud::Model::Path do 
    skip_create
    sequence :name do |n|
      "path_#{n}"
    end

    sequence :object do |n|
      "path_object_#{n}"
    end
  end

  factory :location, :class => ObjMud::Model::Location do
    skip_create
    sequence :object do |n|
      "location_object_#{n}"
    end
  end

  factory :location_with_paths, :parent => :location do
    skip_create
    after(:create) do |instance, evaluator|
      instance.paths = FactoryGirl.create_list(:path, 4)
    end
  end

  factory :viewer, :class => ObjMud::Model::Viewer do
    skip_create
    association :location, :factory => :location_with_paths
  end
end
