# frozen_string_literal: true
class AddFieldsToMentor < ActiveRecord::Migration[5.0]
  def change
    add_column :mentors, :first_name, :string
    add_column :mentors, :last_name, :string
    add_column :mentors, :email, :string
    add_column :mentors, :phone_number, :string
    add_column :mentors, :linkedin, :string
    add_column :mentors, :facebook, :string
    add_column :mentors, :city, :string
    add_column :mentors, :description, :text
  end
end
