class CreateClockEvents < ActiveRecord::Migration
  def change
    create_table :clock_events do |t|
      t.integer :user_id, :null => false
      t.datetime :time_in, :null => false
      t.datetime :time_out
      t.string :notes, :limit => 500
      t.integer :status, :null => false

      t.timestamps
    end

    add_index :clock_events, :user_id
  end
end
