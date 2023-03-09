require 'rails_helper'

describe 'interaction for ImagesController' do
  include HotGlue::ControllerHelper
  include ActionView::RecordIdentifier

  #HOTGLUE-SAVESTART
  #HOTGLUE-END
  

  let!(:image1) {create(:image , name: FFaker::Movie.title )}
  
  describe "index" do
    it "should show me the list" do
      visit images_path
      expect(page).to have_content(image1.name)
    end
  end

  describe "new & create" do
    it "should create a new Image" do
      visit images_path
      click_link "New Image"
      expect(page).to have_selector(:xpath, './/h3[contains(., "New Image")]')
      new_name = FFaker::Movie.title 
      find("[name='image[name]']").fill_in(with: new_name)
      click_button "Save"
      expect(page).to have_content("Successfully created")
      expect(page).to have_content(new_name)
    end
  end


  describe "edit & update" do
    it "should return an editable form" do
      visit images_path
      find("a.edit-image-button[href='/images/#{image1.id}/edit']").click

      expect(page).to have_content("Editing #{image1.name.squish || "(no name)"}")
      new_name = FFaker::Movie.title 
      find("[name='image[name]']").fill_in(with: new_name)
      click_button "Save"
      within("turbo-frame#__#{dom_id(image1)} ") do
        expect(page).to have_content(new_name)
      end
    end
  end 

  describe "destroy" do
    it "should destroy" do
      visit images_path
      accept_alert do
        find("form[action='/images/#{image1.id}'] > input.delete-image-button").click
      end
      expect(page).to_not have_content(image1.name)
      expect(Image.where(id: image1.id).count).to eq(0)
    end
  end
end

