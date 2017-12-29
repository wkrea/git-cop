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
          return true if filter_list.empty?
          commit.subject.match?(/#{Regexp.union filter_list.to_regexp}\Z/)
        end

        def issue
          return {} if valid?
          {hint: %(Use: #{filter_list.to_hint}.)}
        end

        protected

        def load_filter_list
          Kit::FilterList.new settings.fetch(:whitelist)
        end
      end
    end
  end
end
