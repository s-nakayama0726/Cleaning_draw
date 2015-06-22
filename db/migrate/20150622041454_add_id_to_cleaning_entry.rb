class AddIdToCleaningEntry < ActiveRecord::Migration
  def change
    add_column :cleaning_entries, :user_id, :string
    add_column :cleaning_entries, :pass, :string
  end
end
