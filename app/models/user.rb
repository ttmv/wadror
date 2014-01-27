class User < ActiveRecord::Base
  has_many :ratings

  include RatingAverage

end
