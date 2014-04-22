class AddNewzealandPlaceToPlace < ActiveRecord::Migration
  def change
    add_column :places, :new_zealand, :boolean
  end
end
