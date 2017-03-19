# frozen_string_literal: true
class AddExtraFieldsToMentor < ActiveRecord::Migration[5.0]
  def change
    add_column :mentors, :organization, :string
    add_column :mentors, :position, :string
    add_column :mentors, :occupation, :string
    add_column :mentors, :availability, :float
  end
end
