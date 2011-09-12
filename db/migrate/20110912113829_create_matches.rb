class CreateMatches < ActiveRecord::Migration
  def up
    create_table :matches do |t|
      t.integer :team_dom_id
      t.integer :team_ext_id

      t.integer :competition_id

      t.string :city
      t.datetime :date
      t.integer :score_dom
      t.integer :score_ext
      t.integer :day_number
      t.text :description
      t.boolean :withdrawal, :default => false #forfait

      t.integer :player_1_id
      t.integer :player_1_bis_id
      t.integer :player_2_id
      t.integer :player_2_bis_id
      t.integer :player_3_id
      t.integer :player_3_bis_id
      t.integer :player_4_id
      t.integer :player_4_bis_id
      t.integer :player_5_id
      t.integer :player_5_bis_id
      t.integer :player_6_id
      t.integer :player_6_bis_id
      t.integer :player_7_id
      t.integer :player_7_bis_id

      t.timestamps
    end
  end

  def down
    drop_table :matches
  end
end
