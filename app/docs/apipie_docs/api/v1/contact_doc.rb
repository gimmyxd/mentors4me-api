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
          param :first_name, String, desc: 'Sender first name', required: false
          param :last_name, String, desc: 'Sender last name', required: false
          param :email, String, desc: 'Sender email', required: false
          param :message, String, desc: 'Sender message', required: false
        end
      end
    end
  end
end
