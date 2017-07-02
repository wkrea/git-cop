# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitAuthorNameParts < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            minimum: 2
          }
        end

        def valid?
          return false if parts.size < minimum
          parts.all? { |name| !String(name).empty? }
        end

        def issue
          return {} if valid?

          {
            label: "Invalid name.",
            hint: %(Detected #{parts.size} out of #{minimum} parts required.)
          }
        end

        private

        def full_name
          commit.author_name.strip
        end

        def minimum
          settings.fetch :minimum
        end

        def parts
          full_name.split(/\s{1}/)
        end
      end
    end
  end
end
