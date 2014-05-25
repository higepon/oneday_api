class Api::RoomsController < ApplicationController
  respond_to :json

  def index
    respond_with(Room.all, {:only => [:id, :name, :created_at], :methods => [:message_count], :include => [{:user => {:only => [:id, :name]}}]})
  end

  def create
    if params[:name]
      room = Room.new
      room.name = params[:name]
      room.user_id = current_user.id
      room.save!
      respond_with(room, :include => [{:user => {:only => [:id, :name]}}], :only => [:id, :name, :created_at], :location => '/room')
      return
    end
    render json: {:status => :error}
    
  end

end
