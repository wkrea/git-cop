# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyLeadingSpace < Abstract
        def self.defaults
          {enabled: false}
        end

        def severity
          :warn
        end

        def valid?
          false
        end

        def issue
          {
            label: "Deprecated (will be removed in next major release).",
            hint: "Use Commit Body Leading Line instead."
          }
        end
      end
    end
  end
end
