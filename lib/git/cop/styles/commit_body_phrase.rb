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
            excludes: [
              "basically",
              /\beasy\b/,
              "everyone knows",
              "however",
              /\bjust\b/,
              "obviously",
              "of course",
              "simply"
            ]
          }
        end
        # rubocop:enable Metrics/MethodLength

        def valid?
          commit.body_lines.all? { |line| valid_line? line }
        end

        def issue
          return {} if valid?

          {
            hint: %(Avoid: #{filter_list.to_hint}.),
            lines: affected_lines
          }
        end

        protected

        def load_filter_list
          Kit::FilterList.new settings.fetch(:excludes)
        end

        private

        def valid_line? line
          !line.downcase.match? Regexp.new(
            Regexp.union(filter_list.to_regexp).source,
            Regexp::IGNORECASE
          )
        end

        def affected_lines
          commit.body_lines.each.with_object([]).with_index do |(line, lines), index|
            lines << self.class.build_issue_line(index, line) unless valid_line?(line)
          end
        end
      end
    end
  end
end
