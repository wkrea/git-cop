# frozen_string_literal: true

module Git
  module Cop
    module Errors
      class Severity < Base
        LEVELS = %i[warn error].freeze

        def initialize level:
          super %(Invalid severity level: #{level}. Use: #{LEVELS.join ", "}.)
        end
      end
    end
  end
end
