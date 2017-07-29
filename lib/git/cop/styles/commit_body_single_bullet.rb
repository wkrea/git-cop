# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodySingleBullet < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            whitelist: %w[\\-]
          }
        end

        def valid?
          bullet_lines.size != 1
        end

        def issue
          return {} if valid?

          {
            hint: "Use paragraph instead of single bullet.",
            lines: affected_lines
          }
        end

        protected

        def load_graylist
          Kit::Graylist.new settings.fetch :whitelist
        end

        private

        def bullet? line
          line.match?(/\A#{Regexp.union graylist.to_regexp}\s+/)
        end

        def bullet_lines
          commit.body_lines.select { |line| bullet? line }
        end

        def affected_lines
          commit.body_lines.each.with_object([]).with_index do |(line, lines), index|
            lines << {number: index + 1, content: line} if bullet?(line)
          end
        end
      end
    end
  end
end
