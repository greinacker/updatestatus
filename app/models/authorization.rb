# == Schema Information
# Schema version: 20110521214144
#
# Table name: authorizations
#
#  id         :integer         not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#  secret     :string(255)
#

class Authorization < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider, :token
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash["provider"], hash["uid"])
  end

  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash!(hash)
    Authorization.create(:user => user, 
                         :uid => hash["uid"], 
                         :provider => hash["provider"],
                         :token => hash["credentials"]["token"],
                         :secret => hash["credentials"]["secret"])
  end
  
end
