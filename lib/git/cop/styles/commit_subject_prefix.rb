# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitSubjectPrefix < Abstract
        def self.defaults
          {
            enabled: true,
            prefixes: %w[Fixed Added Updated Removed Refactored]
          }
        end

        def valid?
          return true if prefixes.empty?
          commit.subject.match?(/\A#{Regexp.union prefixes}/)
        end

        def error
          return "" if valid?
          %(Invalid prefix. Use: #{formatted_prefixes.join ", "}.)
        end

        private

        def prefixes
          settings.fetch :prefixes
        end

        def formatted_prefixes
          prefixes.map { |prefix| %("#{prefix}") }
        end
      end
    end
  end
end
