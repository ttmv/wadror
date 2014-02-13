class BeerClub < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :users, through: :memberships

  def member?(user)
    users.include? user
  end
end
