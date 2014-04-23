class AddPersistedPriceAndCostToMail < ActiveRecord::Migration
  def change
    add_column :mails, :persisted_prices, :text #Actually an array. lel
    add_column :mails, :persisted_costs, :text
  end
end
