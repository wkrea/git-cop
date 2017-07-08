# frozen_string_literal: true

module Git
  module Cop
    module Kit
      class String
        def self.pluralize word, count:, suffix: "s"
          return "#{count} #{word}" if count == 1
          "#{count} #{word}#{suffix}"
        end
      end
    end
  end
end
