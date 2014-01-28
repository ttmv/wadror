class User < ActiveRecord::Base
  include RatingAverage
  
  has_many :ratings, :dependent => :destroy
  has_many :beers, through: :ratings

  has_secure_password

  validates :username, uniqueness: true, length: {minimum: 3, maximum: 15}
  validates :password, length: {minimum: 4}
  validates :password, format: {with: /[A-Z]/}
  validates :password, format: {with: /\d/}

end 
