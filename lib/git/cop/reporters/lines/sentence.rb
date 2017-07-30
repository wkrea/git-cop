# frozen_string_literal: true

module Git
  module Cop
    module Reporters
      module Lines
        class Sentence
          INDENT = "    "

          def initialize data = {}
            @data = data
          end

          def to_s
            %(#{INDENT}Line #{number}: "#{content}"\n)
          end

          private

          attr_reader :data

          def number
            data.fetch :number
          end

          def content
            data.fetch :content
          end
        end
      end
    end
  end
end
