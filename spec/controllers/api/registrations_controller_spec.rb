require 'spec_helper'

describe Api::RegistrationsController do
  fixtures(:all)
  before do
    request.accept = 'application/json'
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#create' do
    context 'when too short password is given' do
      it 'should return error' do
        post :create, { :user => { :email => 'higepon@gmail.com', :password => 'a'} }
        expect(response).not_to be_success
        json = JSON.parse(response.body)
        expect(json['errors'].size).to be > 0
        expect(json['errors']['password'][0]).to eq('is too short (minimum is 8 characters)')
      end
    end

    context 'when account already exists' do
      it 'should return error' do
        post :create, { :user => { :email => 'user001@gmail.com', :password => 'abcdefghijklmno' } }
        expect(response).not_to be_success
#        puts response.body
        json = JSON.parse(response.body)
        expect(json['errors'].size).to be > 0
        expect(json['errors']['email'][0]).to eq('has already been taken')
      end
    end

    context 'when invalid email is geven' do
      it 'should return error' do
        post :create, { :user => { :email => 'user001', :password => 'abcdefghijklmno' } }
        expect(response).not_to be_success
        json = JSON.parse(response.body)
        expect(json['errors'].size).to be > 0
        expect(json['errors']['email'][0]).to eq('is invalid')
      end
    end

    context 'when user sign up' do
      it 'should return user mobile authentication_token' do
        post :create, { :user => { :email => 'john@gmail.com', :password => 'abcdefghijklmno', :name => 'hagepon' } }
#        puts response.body
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['success']).to eq(true)
        expect(json['user']['authentication_token'].size).to be > 0
      end
    end
  end
end
