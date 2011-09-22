class ChangeNotationDoneColumn < ActiveRecord::Migration
  def up
    #On ne peut modifier une colonne d'un entier vers un booleen
    remove_column :participations, :notation_done
    add_column :participations, :notation_done, :boolean, :default => false
  end

  def down
    remove_column :participations, :notation_done
    add_column :participations, :notation_done, :integer
  end
end
