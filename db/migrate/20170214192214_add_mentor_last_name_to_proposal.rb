class AddMentorLastNameToProposal < ActiveRecord::Migration[5.0]
  def change
    add_column :proposals, :mentor_last_name, :string
  end
end
