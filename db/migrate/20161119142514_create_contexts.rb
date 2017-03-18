# frozen_string_literal: true
class CreateContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :contexts do |t|
      t.text :description
      t.references :mentor, foreign_key: true
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
