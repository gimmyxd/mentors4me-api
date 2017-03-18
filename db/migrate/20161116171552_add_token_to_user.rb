# frozen_string_literal: true
class AddTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true
    add_column :users, :auth_token_created_at, :datetime
  end
end
