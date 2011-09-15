class AddCompositionToMatches < ActiveRecord::Migration
  def up
    add_column :matches, :composition, :string
  end

  def down
    remove_column :matches, :composition
  end
end
