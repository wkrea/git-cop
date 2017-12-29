# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyBullet < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            blacklist: %w[\\* •]
          }
        end

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
          Kit::FilterList.new settings.fetch :blacklist
        end

        private

        # :reek:FeatureEnvy
        def valid_line? line
          return true if line.strip.empty?
          line.match?(/\A(?!\s*#{Regexp.union filter_list.to_regexp}\s+).+\Z/)
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
