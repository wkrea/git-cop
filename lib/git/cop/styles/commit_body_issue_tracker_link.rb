# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyIssueTrackerLink < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            blacklist: [
              "(f|F)ix(es|ed)?\\s\\#\\d+",
              "(c|C)lose(s|d)?\\s\\#\\d+",
              "(r|R)esolve(s|d)?\\s\\#\\d+",
              "github\\.com\\/.+\\/issues\\/\\d+"
            ]
          }
        end

        def valid?
          commit.body_lines.none? { |line| invalid_line? line }
        end

        def issue
          return {} if valid?

          {
            hint: "Explain issue instead of using link. Avoid: #{graylist.to_hint}.",
            lines: affected_lines
          }
        end

        protected

        def load_graylist
          Kit::Graylist.new settings.fetch :blacklist
        end

        private

        def invalid_line? line
          line.match?(/.*#{Regexp.union graylist.to_regexp}.*/)
        end

        def affected_lines
          commit.body_lines.each.with_object([]).with_index do |(line, lines), index|
            lines << self.class.build_issue_line(index, line) if invalid_line?(line)
          end
        end
      end
    end
  end
end
