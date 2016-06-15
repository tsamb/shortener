require 'rails_helper'

RSpec.feature "Links resource", type: :feature do
  before :each do
    User.create!(:username => 'sam', :password => 'password')
    visit '/login'
    within('form') do
      fill_in 'Username', :with => 'sam'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Login'
  end

  feature "Creating links" do
    context "with valid input" do
      scenario "User creates a link" do
        click_link 'New Link'
        within('form') do
          fill_in 'Full url', :with => 'goog'
          fill_in 'Short url', :with => 'http://www.google.com'
        end
        click_button 'Create Link'
        
        expect(page).to have_content 'Link was successfully created.'
        expect(page).to have_content 'Click count: 0'
        expect(page).to have_content 'User information will appear as soon as people have used the shortened link.'
        expect(page).to_not have_content 'User agent string'
      end
    end

    context "with invalid input" do

    end
  end
end