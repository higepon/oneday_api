class Api::RoomsController < ApplicationController
  respond_to :json

  def index
    respond_with(Room.all, {:only => [:id, :name, :created_at], :include => [{:user => {:only => [:id, :name]}}]})
  end

end
