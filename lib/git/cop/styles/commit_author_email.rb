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
          return "" if valid?
          %(Invalid email: "#{email}". Use format: <name>@<server>.<domain>.)
        end

        private

        def email
          commit.author_email
        end
      end
    end
  end
end
