require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:link) { Link.create(full_url: "http://www.google.com", short_url: "thegoog") }

  describe "attributes" do
    it "has a short_url" do
      expect(link.short_url).to eq("thegoog")
    end

    it "has a full_url" do
      expect(link.full_url).to eq("http://www.google.com")
    end
  end

  describe "validations" do
    it "is valid with a full_url and a short_url" do
      expect(link).to be_valid
    end

    it "is invalid without a full_url" do
      link_no_full_url = Link.new(full_url: "", short_url: "thegoog")
      expect(link_no_full_url).to be_invalid
    end

    it "is invalid without a short_url" do
      link_no_short_url = Link.new(full_url: "http://www.google.com", short_url: "")
      expect(link_no_short_url).to be_invalid
    end
  end
end
