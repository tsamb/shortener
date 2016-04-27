require 'rails_helper'

RSpec.describe "links/new", type: :view do
  before(:each) do
    assign(:link, Link.new(
      :full_url => "MyText",
      :short_url => "MyString"
    ))
  end

  it "renders new link form" do
    render

    assert_select "form[action=?][method=?]", links_path, "post" do

      assert_select "textarea#link_full_url[name=?]", "link[full_url]"

      assert_select "input#link_short_url[name=?]", "link[short_url]"
    end
  end
end
