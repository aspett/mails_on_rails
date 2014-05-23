require "spec_helper"

describe SessionsController do

  context 'logged out' do
    let :valid_user do
      User.create(username: 'user1', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Manager')
    end

    let :valid_user_details do
      { username: 'user1', password: 'aaaaaaaaaa' }
    end

    let :invalid_user_details do
      { username: 'no', password: 'aaaaaaaaaa' }
    end

    before :all do
      valid_user
    end

    after :each do
      User.delete_all
    end

    context 'valid details' do
      it 'logs in' do
        post :create, valid_user_details
        expect(session[:user_id]).to_not be_nil
      end
    end

    context 'invalid details' do
      it 'doesnt log in' do
        post :create, invalid_user_details
        expect(session[:user_id]).to be_nil
      end
    end
  end

  context 'logged in' do
    let :valid_user do
      User.create(username: 'user1', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Manager')
    end

    let :valid_user_details do
      { username: 'user1', password: 'aaaaaaaaaa' }
    end

    it 'does not let you log in again' do
      post :create, valid_user_details, {user_id: User.where(username: 'user1').first.id }
      expect(request.flash[:error]).to_not be_nil
    end

    it 'logs out correctly' do
      delete :delete, {}, {user_id: User.where(username: 'user1').first.id}
      expect(session[:user_id]).to be_nil
    end
  end
end
