class Room < ActiveRecord::Base
  attr_accessible :name, :user_id
  has_many :messages
end
