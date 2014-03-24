class Api::MessagesController < ApplicationController

  def index
    ms = Message.find_all_by_room_id(params[:room_id], :order => 'created_at')
    return render :json => { :messages => ms }
  end
  
end
