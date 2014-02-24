class Beer < ActiveRecord::Base
  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, :dependent => :destroy
  has_many :raters, through: :ratings, source: :user

  include RatingAverage
  
  validates :name, presence: true
  validates :style_id, presence: true

  def to_s
    "#{name} #{brewery.name}"
  end 
  
  def self.top(n)
    all.sort_by{ |b| -(b.average_rating||0) }.take(n)
  end
end
