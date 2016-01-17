class User < ActiveRecord::Base
  has_many :hashtags, through: :user_hashtags
  has_many :user_hashtags
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)
    user = create(uid: auth.uid, provider: auth.provider) if  user.nil?
    user.accesstoken = auth.credentials.token
    user.name = auth.info.name
    user.email = auth.info.email
    user.nickname = auth.info.nickname
    user.image = auth.info.image
    user.save!
    user
  end

  def instagram_client
    @instagram_client ||= Instagram.client( access_token: accesstoken )
  end

end
