class Message < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :room
  belongs_to :user
end
