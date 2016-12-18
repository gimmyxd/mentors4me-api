module ApipieDocs
  module Api
    module V1
      module SkillDoc
        extend BaseResource

        def self.superclass
          Api::V1::SkillsController
        end

        doc_for :show do
          api :GET, '/skills/:id', 'Retrevie a specific skill'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end

        doc_for :index do
          api :GET, '/skills', 'Retrevie a list of skills'
          error 401, 'Unauthorized'
        end

        doc_for :create do
          api :POST, '/skills', 'Create a skill'
          param :name, String, desc: 'The name of the skill', required: true
          error 401, 'Unauthorized'
          error 422, 'Validation error'
        end

        doc_for :update do
          api :PUT, '/skills/:id', 'Update a skill'
          param :name, String, desc: 'The name of the skill'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
          error 422, 'Validation error'
        end

        doc_for :destroy do
          api :DELETE, '/skills/:id', 'Delete a skill'
          error 401, 'Unauthorized'
          error 404, 'Not Found'
        end
      end
    end
  end
end
