# frozen_string_literal: true

module ApipieDocs
  module Api
    module V1
      module ContactDoc
        extend BaseResource

        def self.superclass
          Api::V1::ContactsController
        end

        doc_for :create do
          api :POST, '/contacts', 'Send email to contact support'
          param :first_name, String, desc: 'Sender first name', required: true
          param :last_name, String, desc: 'Sender last name', required: true
          param :email, String, desc: 'Sender email', required: true
          param :message, String, desc: 'Sender message', required: true
        end
      end
    end
  end
end
