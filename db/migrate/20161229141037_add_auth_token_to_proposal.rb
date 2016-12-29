class AddAuthTokenToProposal < ActiveRecord::Migration[5.0]
  def change
    remove_column :proposals, :invitation_token, :string
    remove_column :proposals, :invitation_token_created_at, :datetime
    add_column :proposals, :auth_token, :string
    add_column :proposals, :auth_token_created_at, :datetime
    add_index :proposals, :auth_token, unique: true
  end
end
