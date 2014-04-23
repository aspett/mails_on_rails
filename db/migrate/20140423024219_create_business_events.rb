class CreateBusinessEvents < ActiveRecord::Migration
  def change
    create_table :business_events do |t|
      t.datetime  :date
      t.integer   :event_type
      t.text      :details 
      t.timestamps
    end
  end
end
