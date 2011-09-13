class CreateParticipation < ActiveRecord::Migration
  def up
    create_table :participations do |t|
      t.integer :user_id
      t.integer :match_id

      t.integer :goals
      t.integer :passes
      t.decimal :notation
      t.integer :nb_notation
      t.integer :notation_done
      t.string :presence
      t.boolean :convocation, :default => false

      t.timestamps
    end
  end

  def down
    drop_table :participations
  end
end
