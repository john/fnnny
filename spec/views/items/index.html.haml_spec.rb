require 'spec_helper'

describe "items/index" do
  before(:each) do
    assign(:items, [
      FactoryGirl.create(:item),
      FactoryGirl.create(:item)
    ])
  end

  it "renders a list of items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
