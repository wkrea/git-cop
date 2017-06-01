# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitSubjectLength < Abstract
        def self.defaults
          {
            enabled: true,
            length: 50
          }
        end

        def valid?
          commit.subject.size <= length
        end

        def error
          return "" if valid?
          "Invalid length. Use #{length} characters or less."
        end

        private

        def length
          settings.fetch :length
        end
      end
    end
  end
end
