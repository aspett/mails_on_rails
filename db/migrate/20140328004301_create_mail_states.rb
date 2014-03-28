class CreateMailStates < ActiveRecord::Migration
  def change
    create_table :mail_states do |t|
      t.integer :current_location_id
      t.integer :next_destination_id
      t.integer :previous_destination_id
      t.integer :routing_step
      t.integer :state_int
      t.integer :mail_id
      t.timestamps
    end
  end
end
