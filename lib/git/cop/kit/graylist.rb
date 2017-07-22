# frozen_string_literal: true

module Git
  module Cop
    module Kit
      class Graylist
        # Represents a white or black regular expression list which may be used as a cop setting.
        def initialize list = []
          @list = Array list
        end

        def to_hint
          to_regexp.map(&:inspect).join ", "
        end

        def to_regexp
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
