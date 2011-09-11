class CreateTeams < ActiveRecord::Migration
  def up
    create_table :teams do |t|
      t.string :name
      t.string :city
      t.boolean :is_fuzion, :default => false
      t.timestamps
    end
  end

  def down
    drop_table :teams 
  end
end
