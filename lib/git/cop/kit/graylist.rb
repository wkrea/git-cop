# frozen_string_literal: true

module Git
  module Cop
    module Kit
      class Graylist
        # Represents a white or black list which may be used as a cop setting.
        def initialize list = []
          @list = list
        end

        def to_quote
          list.map { |item| %("#{item}") }
        end

        def to_regex
          list.map { |item| Regexp.new item }
        end

        def empty?
          list.empty?
        end

        private

        attr_reader :list
      end
    end
  end
end
