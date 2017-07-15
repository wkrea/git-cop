# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyPresence < Abstract
        using Refinements::Strings

        def self.defaults
          {
            enabled: true,
            severity: :warn,
            minimum: 1
          }
        end

        def valid?
          return true if commit.fixup?
          valid_lines = commit.body_lines.reject { |line| line.match?(/^\s*$/) }
          valid_lines.size >= minimum
        end

        def minimum
          settings.fetch :minimum
        end

        def issue
          return {} if valid?

          {
            label: "Invalid body.",
            hint: %(Use a minimum of #{"line".pluralize count: minimum} (not empty).)
          }
        end
      end
    end
  end
end
