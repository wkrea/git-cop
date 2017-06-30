# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitSubjectSuffix < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            whitelist: ["."]
          }
        end

        def valid?
          return true if whitelist.empty?
          commit.subject.match?(/#{Regexp.union whitelist}\Z/)
        end

        def error
          return "" if valid?
          %(Invalid suffix. Use: #{formatted_whitelist.join ", "}.)
        end

        private

        def whitelist
          settings.fetch :whitelist
        end

        def formatted_whitelist
          whitelist.map { |suffix| %("#{suffix}") }
        end
      end
    end
  end
end
