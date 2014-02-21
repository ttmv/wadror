module RatingAverage
  def average_rating
    #ratings.inject(0) {|n, r| n + r.score}.to_f / ratings.count
    ratings.average :score
  end
end
