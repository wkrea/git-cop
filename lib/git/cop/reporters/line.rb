# frozen_string_literal: true

module Git
  module Cop
    module Reporters
      # Reports issues related to an invalid line within the commit body.
      class Line
        def initialize line = {}
          @line = line
        end

        def to_s
          %(    Line #{number}: "#{content}"\n)
        end

        private

        attr_reader :line

        def number
          line.fetch :number
        end

        def content
          line.fetch :content
        end
      end
    end
  end
end
