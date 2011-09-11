class CreateCompetitions < ActiveRecord::Migration
  def up
    create_table :competitions do |t|
      t.string :name
      t.integer :year
      t.boolean :ended, :default => false
      t.string :competition_type
      t.timestamps
    end
  end

  def down
    drop_table :competitions
  end
end
