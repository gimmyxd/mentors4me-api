# frozen_string_literal: true
class SkillAssignment < ApplicationRecord
  belongs_to :mentor
  belongs_to :skill
end
