# frozen_string_literal: true

module Git
  module Cop
    module Errors
      # The root class of gem related errors.
      # rubocop:disable Style/CommentedKeyword
      class Base < StandardError
        def initialize message = "Invalid #{Identity.label} action."
          super message
        end
      end
    end
  end
end
