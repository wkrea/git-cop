# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyPhrase < Abstract
        # rubocop:disable Metrics/MethodLength
        def self.defaults
          {
            enabled: true,
            severity: :error,
            blacklist: [
              "obviously",
              "basically",
              "simply",
              "of course",
              "just",
              "everyone knows",
              "however",
              "easy"
            ]
          }
        end

        def valid?
          commit.body_lines.all? { |line| valid_line? line }
        end

        def issue
          return "" if valid?

          %(Invalid body. Avoid these phrases: #{formatted_blacklist.join ", "}. ) +
            %(Affected lines:\n#{affected_lines.join "\n"})
        end

        private

        def blacklist
          settings.fetch(:blacklist).map(&:downcase)
        end

        def formatted_blacklist
          blacklist.map { |word| %("#{word}") }
        end

        def valid_line? line
          !line.downcase.match? Regexp.union(blacklist)
        end

        def affected_lines
          commit.body_lines.each.with_object([]).with_index do |(line, lines), index|
            lines << "    Line #{index + 1}: #{line}" unless valid_line?(line)
          end
        end
      end
    end
  end
end
