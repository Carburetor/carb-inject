require "spec_helper"
require "carb/inject/callable_container"

describe Carb::Inject::CallableContainer do
  it "resolves dependency running `call` on it" do
    container = Carb::Inject::CallableContainer.new({ foo: -> { 123 } })

    expect(container[:foo]).to eq 123
  end
end
