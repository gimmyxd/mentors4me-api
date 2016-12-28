class UpdateContextRelation < ActiveRecord::Migration[5.0]
  def change
    change_table :contexts do |t|
      t.remove_references :mentor
      t.remove_references :organization
    end
    add_column :contexts, :mentor_id, :integer
    add_index :contexts, :mentor_id
    add_column :contexts, :organization_id, :integer
    add_index :contexts, :organization_id
  end
end
