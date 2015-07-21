class AddJoincountAndHitcountToCleaningEntry < ActiveRecord::Migration
  def change
    add_column :cleaning_entries, :join_count, :integer
    add_column :cleaning_entries, :hit_count, :integer
  end
end
