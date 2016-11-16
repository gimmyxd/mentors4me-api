class UpdateUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_id, :integer
    add_column :users, :context_id, :integer
    add_column :users, :role, :string
  end
end
