class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings, :dependent => :destroy

  include RatingAverage
  
  validates :name, presence: true

  def to_s
    "#{name}; #{brewery.name}"
  end  
end
