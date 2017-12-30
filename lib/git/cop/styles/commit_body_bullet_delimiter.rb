# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyBulletDelimiter < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            includes: %w[\\-]
          }
        end

        def valid?
          commit.body_lines.none? { |line| invalid_line? line }
        end

        def issue
          return {} if valid?

          {
            hint: "Use space after bullet.",
            lines: affected_lines
          }
        end

        protected

        def load_filter_list
          Kit::FilterList.new settings.fetch :includes
        end

        private

        def invalid_line? line
          line.match?(/\A\s*#{Regexp.union filter_list.to_regexp}(?!\s).+\Z/)
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
