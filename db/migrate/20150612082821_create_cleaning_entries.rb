class CreateCleaningEntries < ActiveRecord::Migration
  def change
    create_table :cleaning_entries do |t|
      t.string :name
      t.integer :draw_no
      t.integer :join_flag

      t.timestamps
    end
  end
end
