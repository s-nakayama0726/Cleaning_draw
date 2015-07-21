class AddRateToCleaningEntry < ActiveRecord::Migration
  def change
    add_column :cleaning_entries, :rate, :float
  end
end
