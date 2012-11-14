require 'spec_helper'

describe "items/show" do
  before(:each) do
    @current_user = FactoryGirl.create(:user)
    @controller.stub!(:current_user).and_return(@current_user)
    @item = assign(:item, FactoryGirl.create(:item))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
