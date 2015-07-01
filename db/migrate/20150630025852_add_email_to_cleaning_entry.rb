class AddEmailToCleaningEntry < ActiveRecord::Migration
  def change
    add_column :cleaning_entries, :email, :string
  end
end
