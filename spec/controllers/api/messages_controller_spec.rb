require 'spec_helper'

describe Api::MessagesController do
  fixtures(:all)
  before do
    request.accept = 'application/json'
  end

  describe '#create' do
    context 'when success' do
      it 'should return success' do
        post :create, { :room_id => 1, :user_email => 'user001@gmail.com', :user_token => 'hoge', :text => "Hi there" }
        expect(response).to be_success
puts response.body
        m = Message.last
        expect(m.room_id).to eq(1)
        expect(m.user.email).to eq("user001@gmail.com")
        expect(m.text).to eq("Hi there")
      end
    end
  end

  describe '#index' do
    context 'when valid room is given' do
      it 'should return messages in room in created_at order' do
        get :index, { :room_id => 1, :user_email => 'user001@gmail.com', :user_token => 'hoge' }
#        puts response.body
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json.size).to be == 3
        expect(json[0]['text']).to eq('I like lisp')
        expect(json[1]['text']).to eq('I like scheme')
        expect(json[0]['user']['name']).to eq('John Lennon')
        expect(json[0]['user']['email']).to be_nil
        expect(json[0]['user']['password']).to be_nil
      end
    end

    context 'when since_id is given' do
      it 'should return messages in room in created_at order since since_id' do
        get :index, { :room_id => 1, :user_email => 'user001@gmail.com', :user_token => 'hoge', :since_id => 2 }
#        puts response.body
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json.size).to be == 1
        expect(json[0]['text']).to eq('I like news')
      end
    end

    context 'when invalid room is given' do
      it 'should return empty ' do
        get :index, { :room_id => 2, :user_email => 'user001@gmail.com', :user_token => 'hoge' }
#        puts response.body
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json.size).to be == 0
      end
    end

    context 'when invalid user_token is given' do
      it 'should return error' do
        get :index, { :room_id => 1, :user_email => 'user001@gmail.com', :user_token => 'hack!' }
        expect(response).to be_error
      end
    end
  end
end
