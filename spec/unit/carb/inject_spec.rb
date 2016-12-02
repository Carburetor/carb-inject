require "spec_helper"
require "carb/inject"

describe Carb::Inject do
  it "has a version number" do
    expect(Carb::Inject::VERSION).to be_a String
  end

  it "has DependencyListCacheName set" do
    name = :@__carb_inject_dependency_list__

    expect(Carb::Inject::DependencyListCacheName).to eq name
  end
end
