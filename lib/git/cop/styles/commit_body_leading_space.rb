# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyLeadingSpace < Abstract
        def self.defaults
          {enabled: true}
        end

        def valid?
          commit.raw_body.match?(/\A.+\n\n.+/)
        end

        def error
          return "" if valid?
          "Missing leading space. Use space between subject and body."
        end
      end
    end
  end
end
