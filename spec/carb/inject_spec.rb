require "spec_helper"
require "carb/inject"

describe Carb::Inject do
  it "has a version number" do
    expect(Carb::Inject::VERSION).to be_a String
  end

  it "has DefinitionCacheName set" do
    expect(Carb::Inject::DefinitionCacheName).to eq :@__carb_inject_definition__
  end
end
