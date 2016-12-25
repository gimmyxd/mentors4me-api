class CreateMentors < ActiveRecord::Migration[5.0]
  def change
    create_table :mentors, &:timestamps
    add_belongs_to :users, :mentor
  end
end
