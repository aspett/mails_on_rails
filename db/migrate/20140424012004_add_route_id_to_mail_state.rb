class AddRouteIdToMailState < ActiveRecord::Migration
  def change
    add_column :mail_states, :route_id, :integer
  end
end
