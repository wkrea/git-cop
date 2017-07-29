# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitAuthorEmail < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error
          }
        end

        def valid?
          address = String email
          address.match?(/\A.+\@.+\Z/) && address.match?(/\.{1}.+\Z/)
        end

        def issue
          return {} if valid?
          {hint: %(Use "<name>@<server>.<domain>" instead of "#{email}".)}
        end

        private

        def email
          commit.author_email
        end
      end
    end
  end
end
