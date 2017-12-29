# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyBulletCapitalization < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            whitelist: %w[\\-]
          }
        end

        def valid?
          lowercased_bullets.size.zero?
        end

        def issue
          return {} if valid?

          {
            hint: "Capitalize first word.",
            lines: affected_lines
          }
        end

        protected

        def load_filter_list
          Kit::FilterList.new settings.fetch :whitelist
        end

        private

        def invalid_line? line
          line.match?(/\A\s*#{Regexp.union filter_list.to_regexp}\s[[:lower:]]+/)
        end

        def lowercased_bullets
          commit.body_lines.select { |line| invalid_line? line }
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
