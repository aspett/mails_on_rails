class AddFromNewZealandToMail < ActiveRecord::Migration
  def change
    add_column :mails, :from_overseas, :boolean
  end
end
