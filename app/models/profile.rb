class Profile < ApplicationRecord
  belongs_to :user
  validates :first_name, :last_name, :email, :phone_number, :city, :description, presence: true
  validates_format_of :email, with: Devise.email_regexp
end
