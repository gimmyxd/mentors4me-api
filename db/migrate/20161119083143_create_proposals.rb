class CreateProposals < ActiveRecord::Migration[5.0]
  def change
    create_table :proposals do |t|
      t.string :email
      t.text :description
      t.string :status
      t.belongs_to :user
      t.timestamps
    end
  end
end
