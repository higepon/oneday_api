class Api::MessagesController < ApplicationController
  respond_to :json

  def index
    ms = Message.find_all_by_room_id(params[:room_id], :order => 'created_at')
    respond_with(ms, {:only => [:text, :created_at], :include => [{:user => {:only => [:id, :name]}}]})
  end

    # {:only => [:id, :caption], :methods => [:distance_of_created],
    #                    :include => [{:photos => {:only => [:id, :name],
    #                                              :methods => [:url], 
    #                                              :include => [{:likes => {:include => {:user => {:only => [:avatar_url, :name, :id]}},
    #                                                            :only => [:id, :user]}}]}},
    #                                 {:user => {:only => [:id, :name, :avatar_url]}}]}

  
end
