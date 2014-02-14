require 'spec_helper'

describe "beer" do
  let!(:style) { FactoryGirl.create :style }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "can be added if name is valid" do
    visit new_beer_path
    fill_in('beer_name', with: 'new beer')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "without valid name is not saved and form with error message is shown" do
    visit new_beer_path
    
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)

    expect(page).to have_content "Name can't be blank"
  end
end
