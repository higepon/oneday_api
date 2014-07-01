class Api::RoomsController < ApplicationController
  respond_to :json

  def index
    rooms = Room.all(:order => "created_at desc")
    rooms.each {|room|
      unless room.removed
        if Time.now - room.created_at > 1.day
          room.removed = true
          room.save!
        end
      end
    }
    respond_with(rooms, {:only => [:id, :name, :created_at, :removed], :methods => [:message_count], :include => [{:user => {:only => [:id, :name]}}]})
  end

  def create
    if params[:name]
      room = Room.new
      room.name = params[:name]
      room.user_id = current_user.id
      room.save!
      respond_with(room, :include => [{:user => {:only => [:id, :name]}}], :only => [:id, :name, :created_at, :removed], :methods => [:message_count], :location => '/room')
      return
    end
    render json: {:status => :error}
    
  end

end
