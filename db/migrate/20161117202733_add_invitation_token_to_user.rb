# frozen_string_literal: true
class AddInvitationTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :invitation_token, :string
    add_index :users, :invitation_token, unique: true
    add_column :users, :invitation_token_created_at, :datetime
  end
end
