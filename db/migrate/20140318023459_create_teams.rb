class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :conference_id
      t.integer :last_year_wins
      t.integer :last_year_losses
      t.integer :wins
      t.integer :losses
      t.integer :owner_id

      t.timestamps
    end
  end
end
