# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitAuthorNameCapitalization < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error
          }
        end

        def valid?
          parts.all? { |name| String(name).match?(/\A[[:upper:]].*\Z/) }
        end

        def error
          return "" if valid?
          %(Invalid name: "#{full_name}". Capitalize each part of name.)
        end

        private

        def full_name
          commit.author_name
        end

        def parts
          full_name.split(/\s{1}/)
        end
      end
    end
  end
end
