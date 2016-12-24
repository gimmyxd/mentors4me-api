class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :slug
      t.string :description

      t.timestamps
    end
    add_index :roles, :slug, unique: true

    reversible do |change|
      change.up do
        Rake::Task['generate_user_roles'].invoke
      end
    end
  end
end
