# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitSubjectSuffix < Abstract
        def self.defaults
          {
            enabled: true,
            suffixes: ["."]
          }
        end

        def valid?
          return true if suffixes.empty?
          commit.subject.match?(/#{Regexp.union suffixes}\Z/)
        end

        def error
          return "" if valid?
          %(Invalid suffix. Use: #{formatted_suffixes.join ", "}.)
        end

        private

        def suffixes
          settings.fetch :suffixes
        end

        def formatted_suffixes
          suffixes.map { |suffix| %("#{suffix}") }
        end
      end
    end
  end
end
