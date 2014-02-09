require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a too short password" do
    user = User.create username:"Pekka", password:"M3h", password_confirmation:"M3h"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password consisting only letters" do
    user = User.create username:"Pekka", password:"passwordWithOnlyLetters",        
                                         password_confirmation:"passwordWithOnlyLetters"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)    
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "does not exist without ratings" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      style = create_beer_with_rating(32, user)

      expect(user.favorite_style).to eq("Lager")
    end

    it "is the one with highest average rating if several beers rated" do
      create_beers_with_ratings(1,2,user)
      beer = FactoryGirl.create(:beer, style:"IPA")
      best = FactoryGirl.create(:rating, beer:beer, score:30, user:user)

      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "does not exist without ratings" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      create_brewery_with_rated_beer(10, "Koff", user)
   
      expect(user.favorite_brewery).to eq("Koff")
    end 

    it "is the one with highest average rating if several beers rated" do
      create_brewery_with_rated_beer(10, "Koff", user)
      create_brewery_with_rated_beer(20, "Koff", user)
      create_brewery_with_rated_beer(30, "BrewDog", user)

      expect(user.favorite_brewery).to eq("BrewDog")
    end   
  end
end


