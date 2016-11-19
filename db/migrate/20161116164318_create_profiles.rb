class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles, &:timestamps
    add_belongs_to :users, :profile
  end
end
