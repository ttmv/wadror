require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
      [ Place.new(name: "Oljenkorsi", id:123) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button 'Search'

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, all are shown at the page" do
    places = []
    
    places << Place.new(name: "Belge", id:1)
    places << Place.new(name: "Kaisla", id:2)
    places << Place.new(name: "Pikkulintu", id:3)
  
    BeermappingApi.stub(:places_in).with("helsinki").and_return(places)

    visit places_path
    fill_in('city', with: 'helsinki')
    click_button 'Search'

    expect(page).to have_content "Belge"
    expect(page).to have_content "Kaisla"
    expect(page).to have_content "Pikkulintu"
  end

  it "if no places found, message about it is shown on the page" do
    BeermappingApi.stub(:places_in).with("kempele").and_return([])
    
    visit places_path
    fill_in('city', with: 'kempele')
    click_button 'Search'

    expect(page).to have_content "No locations in kempele"
  end
end
