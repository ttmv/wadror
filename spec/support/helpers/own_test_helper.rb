module OwnTestHelper

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end

  def create_brewery_with_rated_beer(score, name, user)
    brewery = FactoryGirl.create(:brewery, name:name)
    beer = FactoryGirl.create(:beer, brewery:brewery)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  end
end

