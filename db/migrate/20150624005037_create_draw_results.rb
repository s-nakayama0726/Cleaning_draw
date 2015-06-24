class CreateDrawResults < ActiveRecord::Migration
  def change
    create_table :draw_results do |t|
      t.integer :vacuum_id
      t.integer :wipe_id
      t.integer :result_flag

      t.timestamps
    end
  end
end
