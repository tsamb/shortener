require 'rails_helper'

RSpec.describe "log in and out", type: :feature do
  before :each do
    User.create!(:username => 'sam', :password => 'password')
  end
  context "with valid credentials" do
    it "signs a user in" do
      visit '/login'
      within("form") do
        fill_in 'Username', :with => 'sam'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Login'
      expect(page).to have_content 'Successfully logged in.'
    end
  end

  context "" do
    
  end
end