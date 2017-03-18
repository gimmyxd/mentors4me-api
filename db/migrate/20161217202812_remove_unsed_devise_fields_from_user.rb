# frozen_string_literal: true
class RemoveUnsedDeviseFieldsFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :invitation_token, :string
    remove_column :users, :invitation_token_created_at, :datetime
    ## Recoverable
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime

    ## Rememberable
    remove_column :users, :remember_created_at, :datetime

    ## Trackable
    remove_column :users, :sign_in_count, :integer
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users,     :current_sign_in_ip, :inet
    remove_column :users,     :last_sign_in_ip, :inet

    ## Confirmable
    remove_column :users, :confirmation_token, :string
    remove_column :users, :confirmed_at, :datetime
    remove_column :users, :confirmation_sent_at, :datetime
  end
end
