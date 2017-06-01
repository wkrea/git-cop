# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyLineLength < Abstract
        def self.defaults
          {
            enabled: true,
            length: 72
          }
        end

        def valid?
          commit.body_lines.all? { |line| valid_line? line }
        end

        def error
          return "" if valid?

          "Invalid line length. Use #{length} characters or less per line. " \
          "Affected lines:\n#{affected_lines.join}"
        end

        private

        def length
          settings.fetch :length
        end

        def valid_line? line
          line.length <= length
        end

        def affected_lines
          commit.body_lines.each.with_object([]).with_index do |(line, lines), index|
            lines << "    Line #{index + 1}: #{line}\n" unless valid_line?(line)
          end
        end
      end
    end
  end
end
