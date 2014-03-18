class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.date :year
      t.integer :current_round
      t.integer :pick_number
      t.integer :user_id
      t.datetime :last_pick

      t.timestamps
    end
  end
end
