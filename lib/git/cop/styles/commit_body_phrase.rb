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
            hint: %(Avoid: #{graylist.to_hint}.),
            lines: affected_lines
          }
        end

        protected

        def load_graylist
          Kit::Graylist.new settings.fetch(:blacklist)
        end

        private

        def valid_line? line
          !line.downcase.match? Regexp.new(
            Regexp.union(graylist.to_regexp).source,
            Regexp::IGNORECASE
          )
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
