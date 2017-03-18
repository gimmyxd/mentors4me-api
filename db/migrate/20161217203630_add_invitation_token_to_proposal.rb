# frozen_string_literal: true
class AddInvitationTokenToProposal < ActiveRecord::Migration[5.0]
  def change
    add_column :proposals, :invitation_token, :string
    add_column :proposals, :invitation_token_created_at, :datetime
    add_index :proposals, :invitation_token, unique: true
  end
end
