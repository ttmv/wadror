require 'spec_helper'

describe Beer do
  it "is saved with name and style " do
    beer = Beer.create name:"testname", style: "teststyle"
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    beer = Beer.create style: "teststyle"
    expect(beer).not_to be_valid
  end

  it "is not saved without style" do
    beer = Beer.create name: "testname"
    expect(beer).not_to be_valid
  end
end
