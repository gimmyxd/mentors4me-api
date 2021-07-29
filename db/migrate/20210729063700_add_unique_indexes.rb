class AddUniqueIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :mentors, [:id], :unique => true
    add_index :organizations, [:id], :unique => true
    add_index :proposals, [:mentor_email], :unique => true
    remove_index :contexts, [:mentor_id]
    remove_index :contexts, [:organization_id]
    add_index :contexts, [:mentor_id, :organization_id], :unique => true
    add_index :skills, [:name], :unique => true
  end
end
