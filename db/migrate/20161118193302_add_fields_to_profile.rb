class AddFieldsToProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
    add_column :profiles, :email, :string
    add_column :profiles, :phone_number, :string
    add_column :profiles, :linkedin, :string
    add_column :profiles, :facebook, :string
    add_column :profiles, :city, :string
    add_column :profiles, :description, :text
  end
end
