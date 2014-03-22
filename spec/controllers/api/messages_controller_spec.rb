require 'spec_helper'

describe Api::MessagesController do
  fixtures(:all)
  before do
    request.accept = 'application/json'
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
end
