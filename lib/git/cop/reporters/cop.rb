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

        def severity_label
          cop.severity.to_s.upcase
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

        def message
          "  #{severity_label}: #{cop.class.label}. " \
          "#{issue.fetch(:label)} #{issue.fetch(:hint)}\n" \
          "#{affected_lines}"
        end
      end
    end
  end
end
