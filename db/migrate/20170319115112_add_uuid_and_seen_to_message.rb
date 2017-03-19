# frozen_string_literal: true
class AddUuidAndSeenToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :uuid, :string, null: false
    add_column :messages, :seen, :boolean, null: false, default: false
    add_index :messages, :uuid, unique: true
  end
end
