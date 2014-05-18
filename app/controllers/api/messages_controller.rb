class Api::MessagesController < ApplicationController
  respond_to :json

  def index
    if (params[:since_id])
      ms = Message.where(:room_id => params[:room_id]).where('id > ?', params[:since_id]).order(:id)
    else
      ms = Message.where(:room_id => params[:room_id]).order(:id)
    end
    respond_with(ms, {:only => [:id, :text, :created_at], :include => [{:user => {:only => [:id, :name]}}]})
  end

  def create
    if params[:text]
      m = Message.new
      m.text = params[:text]
      m.room_id = params[:room_id]
      m.user_id = current_user.id
      m.save!
      if m.text =~ /^@(.+):.*/
        handle_mention($1)
      end
      respond_with(m, :include => [{:user => {:only => [:id, :name]}}], :only => [:id, :text, :created_at], :location => '/messages')
      return
    end
    render json: {:status => :error}
  end

private
  def handle_mention(name)
    # User.find_by_name(name).each {|user|
    # EM.defer do
    #   n = Rpush::Apns::Notification.new
    #   n.app = Rapns::Apns::App.find_by_name("OneDayDev")
    #   dest.devices.each {|device|
    #     n.device_token = device.token
    #     n.alert = "#{@user.name} starts following you"
    #     n.attributes_for_device = {:user_id => @user.id, :type => "new_friend" }
    #     n.save!
    #   }
    #   Rapns.push
    # end
      
    # }
  end
end
