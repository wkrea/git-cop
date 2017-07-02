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
          return {} if valid?

          {
            label: "Invalid body.",
            hint: %(Avoid these phrases: #{formatted_blacklist.join ", "}.),
            lines: affected_lines
          }
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
            lines << {number: index + 1, content: line} unless valid_line?(line)
          end
        end
      end
    end
  end
end
