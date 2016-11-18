class Organization < ApplicationRecord
  belongs_to :user
  validates :name, :asignee, :email, :phone_number, :city, :description, presence: true
  validates_format_of :email, with: Devise.email_regexp
end
