# frozen_string_literal: true

require "pastel"

module Git
  module Cop
    module Reporters
      # Reports issues related to a single cop.
      class Cop
        def initialize cop, colorizer: Pastel.new
          @cop = cop
          @issue = cop.issue
          @colorizer = colorizer
        end

        def to_s
          colorizer.public_send color, message
        end

        private

        attr_reader :cop, :issue, :colorizer

        def message
          "  #{cop.class.label}#{severity_suffix}. " \
          "#{issue.fetch :hint}\n" \
          "#{affected_lines}"
        end

        def severity_suffix
          case cop.severity
            when :warn then " Warning"
            when :error then " Error"
            else ""
          end
        end

        def color
          case cop.severity
            when :warn then :yellow
            when :error then :red
            else :white
          end
        end

        def affected_lines
          issue.fetch(:lines, []).reduce("") { |lines, line| lines + Line.new(line).to_s }
        end
      end
    end
  end
end
