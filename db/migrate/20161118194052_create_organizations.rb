class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.belongs_to :user
      t.string :name
      t.string :asignee
      t.string :email
      t.string :phone_number
      t.string :city
      t.text :description
      t.timestamps
    end
  end
end
