require 'spec_helper'

describe Api::RoomsController do
  fixtures(:all)
  before do
    request.accept = 'application/json'
  end

  describe '#index' do
    context 'when signed-in user' do
      it 'should return rooms' do
        get :index, { :user_email => 'user001@gmail.com', :user_token => 'hoge' }
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json.size).to be == 1
        expect(json[0]['name']).to eq('Scheme')
        expect(json[0]['user']['name']).to eq('John Lennon')
        expect(json[0]['user']['password']).to be_nil
      end
    end
  end

  describe '#context' do
    context 'when signed-in user' do
      it 'should create room' do
        post :create, { :name => 'Hello, World', :user_email => 'user001@gmail.com', :user_token => 'hoge'}
        expect(response).to be_success
        puts response.body
        room = Room.last
        expect(room.name).to eq("Hello, World")
        expect(room.user.name).to eq("John Lennon")
      end
    end
  end
end
