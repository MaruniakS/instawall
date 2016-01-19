class Tag < ActiveRecord::Base
  has_many :user_tags
  has_many :users, through: :user_tags

  validates :name, uniqueness: true
end
