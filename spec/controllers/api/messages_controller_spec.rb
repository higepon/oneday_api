require 'spec_helper'

describe Api::MessagesController do
  fixtures(:all)
  before do
    request.accept = 'application/json'
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#index' do
    context 'when valid room is given' do
      it 'should return messages in room' do
        get :index, { :room_id => 1, :user_email => 'user001@gmail.com', :user_token => 'hoge' }
        puts response.body
        expect(response).to be_success
#        expect(json['success']).to eq(true)
#        expect(json['user']['authentication_token'].size).to be > 0
      end
    end
  end
end
