require 'spec_helper'

describe Api::RegistrationsController do

  before do
    request.accept = 'application/json'
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#create' do
    context 'when too short password is given' do
      it 'should return error' do
        post :create, { :user => { :email => 'higepon@gmail.com', :password => 'a' } }
        expect(response).not_to be_success
        json = JSON.parse(response.body)
        expect(json['errors'].size).to be > 0
        expect(json['errors']['password'][0]).to eq('is too short (minimum is 8 characters)')
        pp json
      end
    end
  end
end
