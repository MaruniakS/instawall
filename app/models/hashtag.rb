class Hashtag < ActiveRecord::Base
  has_many :user_hashtags
  has_many :users, through: :user_hashtags

  validates :hash, uniqueness: true
end
