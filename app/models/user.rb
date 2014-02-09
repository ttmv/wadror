class User < ActiveRecord::Base
  include RatingAverage
  
  has_many :ratings, :dependent => :destroy
  has_many :beers, through: :ratings
  has_many :memberships, :dependent => :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates :username, uniqueness: true, length: {minimum: 3, maximum: 15}
  validates :password, length: {minimum: 4}
  validates :password, format: {with: /[A-Z]/}
  validates :password, format: {with: /\d/}

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = ratings.map{ |r| r.beer.style }.uniq
    avgs = count_avgs(styles)
    avgs.key(avgs.values.max)    
  end

  def favorite_brewery
    return nil if ratings.empty?

    breweries = ratings.map{ |r| r.beer.brewery }.uniq
    avgs = count_brewery_averages(breweries)
    avgs.key(avgs.values.max).name    
  end
end 

def count_avgs(styles)
  avgs = {}
  styles.each do |s|
    amount = ratings.select{ |r| r.beer.style == s }.count
    avgs[s] = ratings.select{ |r| 
       r.beer.style == s
    }.inject(0.0){ |sum, r| sum + r.score} / amount
  end

  avgs
end

def count_brewery_averages(breweries)
  avgs = {}
  breweries.each do |s|
    amount = ratings.select{ |r| r.beer.brewery == s }.count
    avgs[s] = ratings.select{ |r| 
       r.beer.brewery == s
    }.inject(0.0){ |sum, r| sum + r.score} / amount
  end

  avgs
end
