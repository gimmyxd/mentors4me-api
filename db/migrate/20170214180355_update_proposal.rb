class UpdateProposal < ActiveRecord::Migration[5.0]
  def change
    remove_column :proposals, :email, :string
    remove_column :proposals, :description, :text
    add_column :proposals, :proposer_first_name, :string
    add_column :proposals, :proposer_last_name, :string
    add_column :proposals, :proposer_email, :string
    add_column :proposals, :proposer_phone_number, :string
    add_column :proposals, :mentor_first_name, :string
    add_column :proposals, :mentor_organization, :string
    add_column :proposals, :mentor_email, :string
    add_column :proposals, :mentor_phone_number, :string
    add_column :proposals, :mentor_facebook, :string
    add_column :proposals, :mentor_linkedin, :string
    add_column :proposals, :reason, :text
  end
end
