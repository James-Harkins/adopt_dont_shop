require 'rails_helper'

RSpec.describe 'admin_shelters show page' do
  describe 'as a visitor' do
    describe 'when i visit an admin shelter show page' do
      describe 'i see a section for statistics' do
        it 'and it contains the average age of all adoptable pets for that shelter' do
          shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
          shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
          pet_1 = shelter_1.pets.create(name: 'Scrappy', age: 4, breed: 'Great Dane', adoptable: true)
          pet_2 = shelter_1.pets.create(name: 'Sparky', age: 6, breed: 'Great Dane', adoptable: true)
          pet_3 = shelter_1.pets.create!(name: 'Spot', age: 9, breed: 'Great Dane', adoptable: false)
          pet_4 = shelter_2.pets.create!(name: 'Brian', age: 3, breed: 'Great Dane', adoptable: true)

          visit "/admin/shelters/#{shelter_1.id}"

          within "#statistics" do
            expect(page).to have_content("Average Pet Age: 5")
          end
        end

        it 'and it contains the count of adoptable pets for that shelter' do
          shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
          shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
          pet_1 = shelter_1.pets.create(name: 'Scrappy', age: 4, breed: 'Great Dane', adoptable: true)
          pet_2 = shelter_1.pets.create(name: 'Sparky', age: 6, breed: 'Great Dane', adoptable: true)
          pet_3 = shelter_1.pets.create!(name: 'Spot', age: 9, breed: 'Great Dane', adoptable: false)
          pet_4 = shelter_2.pets.create!(name: 'Brian', age: 3, breed: 'Great Dane', adoptable: true)

          visit "/admin/shelters/#{shelter_1.id}"

          within "#statistics" do
            expect(page).to have_content("Number of Adoptable Pets: 2")
          end
        end

#           As a visitor
# When I visit an admin shelter show page
# Then I see a section for statistics
# And in that section I see the number of pets that have been adopted from that shelter
#
# Note: A Pet has been adopted from a shelter if they are part of an approved application
        it 'and it contains the count of adopted pets for that shelter' do
          application_1 = Application.create!(name: 'Chris', address: '505 Main St.', city: 'Denver', state: 'CO', zipcode: '80205', description: "I'm great with dogs.", status: 'In-progress')
          shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
          pet_1 = application_1.pets.create!(name: 'Scrappy', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
          pet_2 = application_1.pets.create!(name: 'Sparky', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
          pet_3 = application_1.pets.create!(name: 'Spot', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
          application_2 = pet_1.applications.create!(name: 'James', address: '1259 N Clarkson St.', city: 'Denver', state: 'CO', zipcode: '80218', description: "Love dogs!", status: 'In-progress')
          application_3 = pet_2.applications.create!(name: 'Ian', address: '4690 S Garrison St.', city: 'Denver', state: 'CO', zipcode: '80123', description: "Love dogs!", status: 'In-progress')

          visit "/admin/applications/#{application_1.id}"

          within "#pet-#{pet_1.id}" do
            click_button "Approve"
          end

          within "#pet-#{pet_3.id}" do
            click_button "Approve"
          end

          visit "/admin/shelters/#{shelter.id}"

          within "#statistics" do
            expect(page).to have_content("Number of Adopted Pets: 2")
          end
        end
      end
    end
  end
end
