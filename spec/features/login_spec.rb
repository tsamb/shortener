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

    it "logs a user out by visiting the logout url" do
      visit '/login'
      within("form") do
        fill_in 'Username', :with => 'sam'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Login'
      expect(page).to have_content 'Successfully logged in.'
      visit '/logout'
      expect(page).to have_content 'Successfully logged out.'
    end
  end

  context "with invalid credentials" do
    it "signs a user in" do
      visit '/login'
      within("form") do
        fill_in 'Username', :with => 'hacker'
        fill_in 'Password', :with => 'wrongpassword'
      end
      click_button 'Login'
      expect(page).to have_content 'Wrong username or password.'
    end

    it "displays a standard error even if the username exists" do
      visit '/login'
      within("form") do
        fill_in 'Username', :with => 'sam'
        fill_in 'Password', :with => 'wrongpassword'
      end
      click_button 'Login'
      expect(page).to have_content 'Wrong username or password.'
    end
  end
end
