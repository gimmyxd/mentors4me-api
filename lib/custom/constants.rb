# frozen_string_literal: true

module Custom
  module Constants
    class Default
      # Hash with exception types and status codes
      EXCEPTIONS = {
        CanCan::AccessDenied => 403,
        ActiveRecord::RecordNotFound => 404,
        ActiveRecord::RecordInvalid => 422,
        ActiveRecord::DeleteRestrictionError => 422,
        ArgumentError => 422
      }.freeze

      EXCEPTIONS_KEYS = {
        CanCan::AccessDenied => 'access_denied',
        ActiveRecord::RecordNotFound => 'record_not_found',
        ActiveRecord::RecordInvalid => 'record_invalid',
        ActiveRecord::DeleteRestrictionError => 'delete_restriction_error',
        ArgumentError => 'argument_error'
      }.freeze
    end

    class User
      ACTIVE = 'active'
      INACTIVE = 'inactive'
    end

    class Role
      ADMIN = 'admin'
      MENTOR = 'mentor'
      ORGANIZATION = 'organization'

      def self.roles
        [ADMIN, MENTOR, ORGANIZATION]
      end
    end

    class Proposal
      ACCEPTED = 'accepted'
      REJECTED = 'rejected'
      PENDING = 'pending'

      def self.statuses
        %w[accepted pending rejected]
      end
    end

    class Context
      ACCEPTED = 'accepted'
      REJECTED = 'rejected'
      PENDING = 'pending'

      def self.statuses
        %w[accepted pending rejected]
      end
    end
  end
end
