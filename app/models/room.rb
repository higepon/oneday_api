class Room < ActiveRecord::Base
  attr_accessible :name, :user_id
  has_many :messages
  belongs_to :user

  def message_count
    messages.count
  end
end
