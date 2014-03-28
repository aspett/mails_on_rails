class CreateMailRoutes < ActiveRecord::Migration
  def change
    create_table :mail_routes do |t|
      t.string :name
      t.string :company
      t.string :transport_type
      t.float :maximum_weight
      t.float :maximum_volume
      t.integer :priority
      t.float :cost_per_weight
      t.float :cost_per_volume
      t.float :price_per_weight
      t.float :price_per_volume
      t.integer :origin_id
      t.integer :destination_id
      t.integer :duration
      t.integer :frequency
      t.datetime :start_date
      t.boolean :active
      t.timestamps
    end
  end
end
