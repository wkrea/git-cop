# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitSubjectSuffix < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error,
            whitelist: ["\\."]
          }
        end

        def valid?
          return true if graylist.empty?
          commit.subject.match?(/#{Regexp.union graylist.to_regex}\Z/)
        end

        def issue
          return {} if valid?

          {
            label: "Invalid suffix.",
            hint: %(Use: #{graylist.to_quote.join ", "}.)
          }
        end

        protected

        def load_graylist
          Kit::Graylist.new settings.fetch(:whitelist)
        end
      end
    end
  end
end
