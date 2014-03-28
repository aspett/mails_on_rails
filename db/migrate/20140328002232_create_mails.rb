class CreateMails < ActiveRecord::Migration
  def change
    create_table :mails do |t|
      t.integer :origin_id
      t.integer :destination_id
      t.integer :priority
      t.datetime :sent_at
      t.datetime :received_at
      t.integer :waiting_time
      t.float :weight
      t.float :volume
      t.float :cost
      t.float :price
      t.text :routes_array
      t.timestamps
    end
  end
end
