class Api::DevicesController < ApplicationController
  respond_to :json

  def create
    device = Device.where(:token => params[:token], :user_id => current_user.id)
    if device.empty?
      device = Device.new(:token => params[:token], :user_id => current_user.id)
      device.save!
    end
    render json: { :status => :ok }
  rescue => e
    puts e
    render json: { :status => :error }, :status => :bad_request
  end
end
