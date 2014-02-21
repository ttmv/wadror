class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, :dependent => :destroy
  has_many :ratings, :through => :beers

  validates :name, presence: true
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  only_integer: true }
  validate :year_not_later_than_current
  
  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil, false] }
  

  def year_not_later_than_current
    if year > Time.now.year
      errors.add(:year, "cannot be later than #{Time.now.year}")
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{ratings.count}"
  end  

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end

  def self.top(n)
    Brewery.all.sort_by{ |b| -(b.average_rating||0) }.take(n) 
  end
end
