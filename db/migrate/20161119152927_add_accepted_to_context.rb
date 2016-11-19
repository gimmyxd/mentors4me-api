class AddAcceptedToContext < ActiveRecord::Migration[5.0]
  def change
    add_column :contexts, :accepted, :boolean, default: false
  end
end
