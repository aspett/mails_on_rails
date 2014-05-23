require "spec_helper"

describe UsersController do
	
	context 'not logged in' do
		context 'accessing user management page' do
			it 'redirects to login' do
				get :index	
				response.should redirect_to(login_path)
			end
		end
	end

	context 'logged in as clerk' do
		let :valid_clerk do
			User.create(username: 'user1', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Clerk')
		end

		before :each do
		  User.delete_all
	      valid_clerk
	    end


		context 'accessing user management' do
			it 'displays invalid access' do
				get :index, nil, {user_id: User.where(username: 'user1').first.id}
				expect(request.flash[:error]).to_not be_nil
			end

			it 'receives 302' do
				get :index, nil, {user_id: User.where(username: 'user1').first.id}
				expect(response.status).to eq 302
			end
		end
	end

	context 'logged in as Manager' do
		let :valid_manager do
			User.create(username: 'user1', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Manager')
		end

		let :other_manager do
			User.create(username: 'user2', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Manager')
		end

		let :valid_clerk do
			User.create(username: 'user3', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Clerk')
		end

		before :each do
		  User.delete_all
	      valid_manager
	      other_manager
	      valid_clerk
	    end

	    let :manager_id do
	    	User.where(username: 'user1').first.id
	    end

	    let :other_manager_id do
	    	User.where(username: 'user2').first.id
	    end

	    let :clerk_id do
	    	User.where(username: 'user3').first.id
	    end

		describe 'accessing user management' do
			it 'response is 200' do
				get :index, nil, {user_id: manager_id}
				expect(response.status).to eq 200
			end
		end

		describe 'user tries demote their own user' do
			it 'displays error message' do
				put :demote, {id: manager_id}, {user_id: manager_id}
				expect(request.flash[:error]).to match "Can not demote yourself"
			end
		end

		describe 'user tries to demote other manager' do
			it 'displays success message' do
				put :demote, {id: other_manager_id}, {user_id: manager_id}
				expect(request.flash[:success]).to match "Successfully demoted user"
			end
		end

		describe 'user tries to promote clerk' do
			it 'displays success message' do
				put :promote, {id: clerk_id}, {user_id: manager_id}
				expect(request.flash[:success]).to match "Successfully promoted user"
			end
		end

		describe 'user tries to remove thier user' do
			it 'displays error message' do
				delete :destroy, {id: manager_id}, {user_id: manager_id}
				expect(request.flash[:error]).to match "There was an error removing this user"
			end
		end

		describe 'user tries to remove another user' do
			it 'displays success message' do
				delete :destroy, {id: clerk_id}, {user_id: manager_id}
				expect(request.flash[:success]).to match "Successfully removed user"
			end

			it 'removes user from db' do
				delete :destroy, {id: clerk_id}, {user_id: manager_id}
				expect(User.where(id: clerk_id).first).to be_nil
			end
		end

		context 'user tries to create another user' do
			describe 'valid new user details' do
				it 'creates new user' do
					post :create, {user:{username: 'user4', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Manager'}}, {user_id: manager_id}
					expect(request.flash[:success]).to match "User created"
				end

				it 'new user exists' do
					post :create, {user:{username: 'user4', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Manager'}}, {user_id: manager_id}
					expect(User.where(username:"user4").first).to_not be_nil
				end
			end

			describe 'with in use username' do
				it 'shows error message' do
					post :create, {user:{username: 'user1', password_confirmation: 'aaaaaaaaaa', password: 'aaaaaaaaaa', role: 'Manager'}}, {user_id: manager_id}
					expect(request.flash[:error]).to match "There was an error creating the user"
				end
			end

			describe 'with differing passwords' do
				it 'shows error message' do
					post :create, {user:{username: 'user4', password_confirmation: 'bbbbbbbb', password: 'aaaaaaaaaa', role: 'Manager'}}, {user_id: manager_id}
					expect(request.flash[:error]).to match "There was an error creating the user"
				end
			end
		end
	end
end