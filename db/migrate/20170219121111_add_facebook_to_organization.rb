class AddFacebookToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :facebook, :string
  end
end
