require 'rails_helper'

RSpec.describe "links/index", type: :view do
  before(:each) do
    assign(:links, [
      Link.create!(
        :full_url => "MyText",
        :short_url => "Short Url"
      ),
      Link.create!(
        :full_url => "MyText",
        :short_url => "Short Url"
      )
    ])
  end

  it "renders a list of links" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Short Url".to_s, :count => 2
  end
end
