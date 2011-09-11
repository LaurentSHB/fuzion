class CreateTeamCompetitions < ActiveRecord::Migration
  def up
    create_table :team_competitions do |t|
      t.integer :team_id
      t.integer :competition_id
      t.integer :penalty
      t.timestamps
    end
  end

  def down
    drop_table :team_competitions
  end
end
