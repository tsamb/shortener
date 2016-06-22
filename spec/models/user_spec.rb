require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(username: "sam", password: "password") }

  describe "attributes" do
    it "has a username" do
      expect(user.username).to eq("sam")
    end

    it "has an encrypted password" do
      expect(user.password_digest).to_not eq("password")
      expect(user.password_digest).to match(/\$2a\$/)
    end
  end

  describe "validations" do
    it "is valid with a username and a password" do
      valid_user = User.new(username: "sam", password: "password")
      expect(valid_user).to be_valid
    end

    it "is invalid without a username" do
      user_no_username = User.new(username: "", password: "password")
      expect(user_no_username).to be_invalid
    end

    it "is invalid without a password" do
      user_no_password = User.new(username: "sam", password: "")
      expect(user_no_password).to be_invalid
    end

    it "is invalid without a password under 8 characters" do
      user_short_password = User.new(username: "sam", password: "short")
      expect(user_short_password).to be_invalid
    end
  end

end
