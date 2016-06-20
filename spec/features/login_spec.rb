require 'rails_helper'

RSpec.feature "FEATURE: Logging in and out", type: :feature do
  before :each do
    User.create!(:username => 'sam', :password => 'password')
  end

  context "with valid credentials" do
    scenario "User signs in" do
      visit '/login'
      within("form") do
        fill_in 'Username', :with => 'sam'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Login'
      expect(page).to have_content 'Successfully logged in.'
    end

    scenario "User logs out" do
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
    scenario "User signs in with nonexistent details" do
      visit '/login'
      within("form") do
        fill_in 'Username', :with => 'hacker'
        fill_in 'Password', :with => 'wrongpassword'
      end
      click_button 'Login'
      expect(page).to have_content 'Wrong username or password.'
    end

    scenario "User signs in with wrong password" do
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
