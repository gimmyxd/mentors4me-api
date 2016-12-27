class AddIndexOnEmailToProposal < ActiveRecord::Migration[5.0]
  def change
    add_index :proposals, :email, unique: true
    change_table :proposals do |t|
      t.remove_references :user
    end
  end
end
