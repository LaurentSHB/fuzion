class CreateUserQualifications < ActiveRecord::Migration
  def change
    create_table :user_qualifications do |t|
      t.integer :user_id
      t.integer :year
      t.boolean :qualified, :default => false
      t.timestamps
    end

    User.all.each do |user|
      [2011, 2012, 2013, 2014, 2015, 2016].each do |year|
        user.user_qualifications.create(:year => year)
      end
    end
  end
end
