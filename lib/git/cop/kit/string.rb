# frozen_string_literal: true

module Git
  module Cop
    module Kit
      class String
        def self.pluralize word, count:, suffix: "s"
          return "#{count} #{word}" if count == 1
          "#{count} #{word}#{suffix}"
        end

        def self.fixup? text
          text.match?(/\Afixup\!\s/)
        end

        def self.squash? text
          text.match?(/\Asquash\!\s/)
        end
      end
    end
  end
end
