require 'spec_helper'

describe Api::MessagesController do
  fixtures(:all)
  before do
    request.accept = 'application/json'
  end

  describe '#index' do
    context 'when valid room is given' do
      it 'should return messages in room in created_at order' do
        get :index, { :room_id => 1, :user_email => 'user001@gmail.com', :user_token => 'hoge' }
        puts response.body
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['messages'].size).to be == 2
        expect(json['messages'][0]['text']).to eq('I like scheme')
        expect(json['messages'][1]['text']).to eq('I like lisp')
      end
    end

    # order
    # invalid room number
  end
end
