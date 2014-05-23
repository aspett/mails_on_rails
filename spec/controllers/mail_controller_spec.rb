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

  context "logged in" do
   
  end
end
