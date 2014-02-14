require 'spec_helper'

describe "User" do
  let!(:user) { FactoryGirl.create :user }

  before :each do
#    user = FactoryGirl.create :user
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end

    it "can remove own ratings from db if signed in" do
      sign_in(username:"Pekka", password:"Foobar1")
      create_beers_with_ratings(22, 33, 44, user)
      visit user_path(user)
      
      expect{
        page.first(:link, "delete").click
      }.to change{Rating.count}.from(3).to(2)
      
      expect(Rating.find_by score:22).to eq(nil)
    end


    it "can see own ratings on own page" do
      user1 = FactoryGirl.create(:user, username: "asdf")
      user2 = FactoryGirl.create(:user, username: "gngn")
      create_beers_with_ratings(44, 20, user1)
      create_beer_with_rating(5, user2)

      visit user_path(user1)

      expect(page).to have_content 'anonymous 44'
      expect(page).to have_content 'anonymous 20'
      expect(page).not_to have_content 'anonymous 5'
    end

    it "has favorite style on own page if has rated beers" do
      create_beers_with_ratings(1,2,user)
      style = FactoryGirl.create(:style, name:"IPA") 
      beer = FactoryGirl.create(:beer, style:style)
      best = FactoryGirl.create(:rating, beer:beer, score:30, user:user)

      visit user_path(user)

      expect(page).to have_content 'Favorite style: IPA'
    end

    it "has favorite brewery on own page if has rated beers" do
      create_brewery_with_rated_beer(21, "Brew1", user)
      create_brewery_with_rated_beer(43, "Brew2", user)
      create_brewery_with_rated_beer(33, "Brew1", user)

      visit user_path(user)

      expect(page).to have_content 'Favorite brewery: Brew2'
    end
  end
end

