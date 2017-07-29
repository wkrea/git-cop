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

        def load_graylist
          Kit::Graylist.new settings.fetch :whitelist
        end

        private

        def invalid_line? line
          line.match?(/\A\s*#{Regexp.union graylist.to_regexp}\s[[:lower:]]+/)
        end

        def lowercased_bullets
          commit.body_lines.select { |line| invalid_line? line }
        end

        def affected_lines
          commit.body_lines.each.with_object([]).with_index do |(line, lines), index|
            lines << {number: index + 1, content: line} if invalid_line?(line)
          end
        end
      end
    end
  end
end
