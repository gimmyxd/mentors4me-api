# frozen_string_literal: true

module ApipieDocs
  module Api
    module V1
      module SessionDoc
        extend BaseResource

        def self.superclass
          Api::V1::SessionsController
        end

        doc_for :create do
          api :POST, '/sessions', 'Login - Creates a new session. Returns an authentication token'
          param :email, String, desc: 'Login email', required: true
          param :password, String, desc: 'Login password', required: true
          error 401, 'Unauthorized'
        end

        doc_for :destroy do
          api :DELETE, '/sessions/:token', 'Logout - Destroys a session'
          error 404, 'Not Found'
        end
      end
    end
  end
end
