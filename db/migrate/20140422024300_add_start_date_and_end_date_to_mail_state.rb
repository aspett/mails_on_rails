class AddStartDateAndEndDateToMailState < ActiveRecord::Migration
  def change
    add_column :mail_states, :start_time, :datetime
    add_column :mail_states, :end_time, :datetime
  end
end
