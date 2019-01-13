# frozen_string_literal: true

module Git
  module Cop
    module Validators
      class Email
        DEFAULT_PATTERN = /\A.+\@.+\.{1}.+\Z/.freeze

        def initialize text, pattern: DEFAULT_PATTERN
          @text = text
          @pattern = pattern
        end

        def valid?
          String(text).match? pattern
        end

        private

        attr_reader :text, :pattern
      end
    end
  end
end
