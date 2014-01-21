class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    #ratings.average('score').to_f
    ratings.inject(0) {|n, r| n + r.score}.to_f / ratings.count
  end  
end
