# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyPresent < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :warn,
            minimum: 1
          }
        end

        def valid?
          valid_lines = commit.body_lines.reject { |line| line.match?(/^\s*$/) }
          valid_lines.size >= minimum
        end

        def minimum
          settings.fetch :minimum
        end

        def issue
          return {} if valid?

          {
            label: "Invalid commit body.",
            hint: "Use at least #{minimum} non-empty line#{"s" if minimum > 1}."
          }
        end
      end
    end
  end
end
