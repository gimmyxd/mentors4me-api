class CreateSkillAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :skill_assignments do |t|
      t.belongs_to :profile, index: true
      t.belongs_to :skill, index: true
      t.timestamps
    end
  end
end
