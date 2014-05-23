require "spec_helper"

describe MailsController do

  let :user do
    User.create(username: "User", password: "aaaaaaaa", password_confirmation: "aaaaaaaa", role: "Manager")
  end
  let :place_one do
    Place.create(name: 'place1', new_zealand: true)
  end

  let :place_two do
    Place.create(name: 'place2', new_zealand: true)
  end

  let :active_route do
    MailRoute.create!(origin_id: place_one.id, destination_id: place_two.id, name: "Route", company: "Company", maximum_weight: 1, maximum_volume: 1, cost_per_weight: 1, cost_per_volume: 1, price_per_weight: 1, price_per_volume: 1, duration: 1, frequency: 1, transport_type: "Land", active: true, start_date: DateTime.now, priority: 0)
  end
  
  before :each do
    user
    active_route
  end

  context "logged in" do
    describe "submitting valid form" do
      let :input_params do
        {mail: {origin_id: "place1", destination_id: "place2", priority: 0, weight: 1, volume: 1, from_overseas: false}}
      end


      it "successfully creates mail" do
        expect(response.status).to eq 200
        expect do
          post :create, input_params, {user_id: user.id}
        end.to change(Mail, :count).by(1)
        expect(request.flash[:error]).to be_nil
      end

      it "creates a route" do
        post :create, input_params, {user_id: user.id}
        expect(Mail.last.routes.count).to eq 1
      end
    end


    describe "submitting incomplete form" do
      let :input_params do
        {mail: {origin_id: "place1",  priority: 0, weight: 1, volume: 1, from_overseas: false}}
      end

      it "redisplays form with error" do
        post :create, input_params, {user_id: user.id}
        expect(request.flash[:error]).to match "error"
        expect(response.status).to eq 200
      end

    end

    describe "submitting invalid route" do
      let :input_params do
        {mail: {origin_id: "place1", destination_id: "placex", priority: 0, weight: 1, volume: 1, from_overseas: false}}
      end

      it "redisplays form with error" do
        post :create, input_params, {user_id: user.id}
        expect(request.flash[:error]).to match "error"
        expect(response.status).to eq 200
      end

    end
  end

  context "not logged in" do
    describe "visiting new mail page" do
      it "redirects to the login page" do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
