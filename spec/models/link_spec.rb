require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:link) { Link.create(full_url: "http://www.google.com", short_url: "thegoog") }

  describe "link" do
    it "has a short_url" do
      expect(link.short_url).to eq("thegoog")
    end
  end
end
