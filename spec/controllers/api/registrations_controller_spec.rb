require 'spec_helper'

describe Api::RegistrationsController do
  describe "#create" do
    context "when too short password is given" do
      it "should return error" do
        request.env["devise.mapping"] = Devise.mappings[:user]
        request.accept = "application/json"
        post :create, { :user => { :email => "higepon@gmail.com", :password => "a" } }
        expect(response).not_to be_success
        body = response.body
        json = JSON.parse(response.body)
        expect(json['errors'].size).to be > 0
        pp json
        puts body
      end
    end
  end
end
