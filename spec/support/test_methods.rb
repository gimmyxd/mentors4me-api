module TestMethods
  module_function

  def find_or_create_role(slug)
    role = Role.find_by(slug: slug)
    role = FactoryGirl.create(:role, slug: slug) unless role
    role.id
  end
end
