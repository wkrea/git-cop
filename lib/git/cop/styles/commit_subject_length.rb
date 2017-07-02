# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitSubjectLength < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            length: 72
          }
        end

        def valid?
          commit.subject.size <= length
        end

        def issue
          return {} if valid?

          {
            label: "Invalid length.",
            hint: "Use #{length} characters or less."
          }
        end

        private

        def length
          settings.fetch :length
        end
      end
    end
  end
end
