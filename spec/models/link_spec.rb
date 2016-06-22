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

    it "has a unique short_url" do
      Link.create!(full_url: "http://www.google.com", short_url: "thegoog")
      link_dup_short = Link.new(full_url: "http://maps.google.com", short_url: "thegoog")
      expect(link_dup_short).to be_invalid
    end
  end

  describe "#click_count" do
    it "returns the count of requests via this link" do
      3.times { link.requests.create!(user_agent: "Mozilla/5.0", accept_language: "en-US", path: "/thegoog") }
      expect(link.click_count).to eq(3)
    end
  end

  describe "#has_clicks?" do
    it "returns true when the short link has been clicked" do
      3.times { link.requests.create!(user_agent: "Mozilla/5.0", accept_language: "en-US", path: "/thegoog") }
      expect(link.has_clicks?).to eq(true)
    end

    it "returns false when the short link has no clicks" do
      expect(link.has_clicks?).to eq(false)
    end
  end

  describe "#user_agent_frequency" do
    it "returns a frequency hash of user agent counts" do
      2.times { link.requests.create!(user_agent: "Mozilla/5.0", accept_language: "en-US", path: "/thegoog") }
      3.times { link.requests.create!(user_agent: "NCSA Mosaic/1.0", accept_language: "en-US", path: "/thegoog") }
      link.requests.create!(user_agent: "Opera/5.11", accept_language: "en-US", path: "/thegoog")
      expect(link.user_agent_frequency).to eq({"Mozilla/5.0" => 2, "NCSA Mosaic/1.0" => 3, "Opera/5.11" => 1})
    end
  end
end
