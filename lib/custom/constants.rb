module Custom
  module Constants
    class Role
      ADMIN = 'admin'.freeze
      MENTOR = 'mentor'.freeze
      ORGANIZATION = 'organization'.freeze

      def self.roles
        [ADMIN, MENTOR, ORGANIZATION]
      end
    end

    class Proposal
      ACCEPTED = 'accepted'.freeze
      REJECTED = 'rejected'.freeze
      PENDING = 'pending'.freeze

      def self.statuses
        %w(accepted pending rejected)
      end
    end

    class Context
      ACCEPTED = 'accepted'.freeze
      REJECTED = 'rejected'.freeze
      PENDING = 'pending'.freeze

      def self.statuses
        %w(accepted pending rejected)
      end
    end
  end
end
