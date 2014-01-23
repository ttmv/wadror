class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings, :dependent => :destroy

  include RatingAverage
  #def average_rating
  #  #ratings.average('score').to_f
  #  ratings.inject(0) {|n, r| n + r.score}.to_f / ratings.count
  #end

  def to_s
    "#{name}; #{brewery.name}"
  end  
end
