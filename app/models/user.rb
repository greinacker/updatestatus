# == Schema Information
# Schema version: 20110521211653
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :authorizations

  def self.create_from_hash!(hash)
    create(:name => hash["user_info"]["name"])
  end
  
  def is_authorized?(provider)
    return !authorizations.find_by_provider(provider).nil?
  end
end
