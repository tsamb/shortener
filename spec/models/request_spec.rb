require 'rails_helper'

RSpec.describe Request, type: :model do
  let(:link) { Link.create!(full_url: "http://www.facebook.com", short_url: "fb") }
  let(:request) do
    Request.create!(user_agent: "Mozilla/5.0",
                    accept_language: "en-US",
                    path: "/fb",
                    link: link)
  end

  describe "attributes" do
    it "has a user_agent" do
      expect(request.user_agent).to eq("Mozilla/5.0")
    end

    it "has an accept_language" do
      expect(request.accept_language).to eq("en-US")
    end

    it "has a path" do
      expect(request.path).to eq("/fb")
    end
  end

  describe "associations" do
    it "belongs to a link" do
      expect(request.link).to eq(link)
    end
  end

  describe "validations" do
    it "is valid with an associated link" do
      expect(request).to be_valid
    end

    it "is invalid without a full_url" do
      linkless_request = Request.new
      expect(linkless_request).to be_invalid
    end
  end
end
