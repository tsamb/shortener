require 'rails_helper'

RSpec.feature "FEATURE: CRUDing links", type: :feature do
  let!(:user) { User.create!(:username => 'sam', :password => 'password') }

  before :each do
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
          fill_in 'Short url', :with => 'goog'
          fill_in 'Full url', :with => 'http://www.google.com'
        end
        click_button 'Create Link'
        
        expect(page).to have_content 'Link was successfully created.'
        expect(page).to have_content 'Click count: 0'
        expect(page).to have_content 'User information will appear as soon as people have used the shortened link.'
        expect(page).to_not have_content 'User agent string'
      end
    end

    context "with invalid input" do
      scenario "User creates a link with neither url filled in" do
        click_link 'New Link'
        click_button 'Create Link'

        expect(page).to_not have_content 'Link was successfully created.'
        expect(page).to have_content "Full url can't be blank"
        expect(page).to have_content "Short url can't be blank"
      end

      scenario "User creates a link without filling in the full url" do
        click_link 'New Link'
        within('form') do
          fill_in 'Short url', :with => 'exists'
        end
        click_button 'Create Link'
        
        expect(page).to_not have_content 'Link was successfully created.'
        expect(page).to have_content "Full url can't be blank"
      end

      scenario "User creates a link without filling in the short url" do
        click_link 'New Link'
        within('form') do
          fill_in 'Full url', :with => 'http://www.google.com'
        end
        click_button 'Create Link'
        
        expect(page).to_not have_content 'Link was successfully created.'
        expect(page).to have_content "Short url can't be blank"
      end

      scenario "User creates a link with an already taken short url" do
        Link.create!(full_url: 'http://maps.google.com', short_url: 'goog', user: user)
        click_link 'New Link'
        within('form') do
          fill_in 'Short url', :with => 'goog'
          fill_in 'Full url', :with => 'http://www.google.com'
        end
        click_button 'Create Link'

        expect(page).to_not have_content 'Link was successfully created.'
        expect(page).to have_content 'Short url has already been taken'
      end
    end
  end

  feature "Editing links" do
    let(:link) { Link.create!(full_url: 'http://www.google.com', short_url: 'goog', user: user) }

    context "with valid input" do
      scenario "User edits a link" do
        visit link_path(link)
        click_link 'Edit'

        expect(find_field('Full url').value).to have_content 'http://www.google.com'
        expect(find_field('Short url').value).to have_content 'goog'

        within('form') do
          fill_in 'Full url', :with => 'googlemaps'
          fill_in 'Short url', :with => 'http://maps.google.com'
        end
        click_button 'Update Link'

        expect(page).to have_content 'Link was successfully updated.'
        expect(page).to have_content 'googlemaps'
        expect(page).to have_content 'http://maps.google.com'
      end
    end

    context "with invalid input" do
      scenario "User creates a link" do
        visit link_path(link)
        click_link 'Edit'

        expect(find_field('Full url').value).to have_content 'http://www.google.com'
        expect(find_field('Short url').value).to have_content 'goog'

        within('form') do
          fill_in 'Full url', :with => ''
          fill_in 'Short url', :with => ''
        end
        click_button 'Update Link'
        
        expect(page).to_not have_content 'Link was successfully updated.'
        expect(page).to have_content "Full url can't be blank"
        expect(page).to have_content "Short url can't be blank"
      end
    end
  end

  feature "Deleting links", js: true do
    let!(:link) { Link.create!(full_url: 'http://www.google.com', short_url: 'goog', user: user) }

    scenario "User deletes a link" do
      visit links_path
      # $stderr.write 'Press enter to continue'
      # $stdin.gets
      expect(page).to have_content 'http://www.google.com'

      accept_alert do
        click_link 'Destroy'
      end

      expect(page).to have_content 'Link was successfully destroyed.'
      expect(page).to_not have_content 'http://www.google.com'
    end
  end

end
