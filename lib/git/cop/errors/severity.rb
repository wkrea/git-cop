# frozen_string_literal: true

module Git
  module Cop
    module Errors
      class Severity < Base
        def initialize level:
          super %(Invalid severity level: #{level}. Use: #{Styles::Abstract::LEVELS.join ", "}.)
        end
      end
    end
  end
end
