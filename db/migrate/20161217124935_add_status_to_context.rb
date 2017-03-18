# frozen_string_literal: true
class AddStatusToContext < ActiveRecord::Migration[5.0]
  def change
    remove_column :contexts, :accepted, :boolean
    add_column :contexts, :status, :string
  end
end
