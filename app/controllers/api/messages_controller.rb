class Api::MessagesController < ApplicationController
  respond_to :json

  def index
    if (params[:since_id])
      ms = Message.where(:room_id => params[:room_id]).where('id > ?', params[:since_id]).order(:id)
    else
      ms = Message.where(:room_id => params[:room_id]).order(:id)
    end
    respond_with(ms, {:only => [:text, :created_at], :include => [{:user => {:only => [:id, :name]}}]})
  end

  def create
    if params[:text]
      m = Message.new
      m.text = params[:text]
      m.room_id = params[:room_id]
      m.user_id = current_user.id
      m.save!
    end
    render json: {:status => :success}
  end
end
