require 'spec_helper'

describe "items/edit" do
  before(:each) do
    @current_user = FactoryGirl.create(:user)
    @controller.stub!(:current_user).and_return(@current_user)
    @item = assign(:item, FactoryGirl.create(:item))
  end

  it "renders the edit item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path(@item), :method => "post" do
    end
  end
end
