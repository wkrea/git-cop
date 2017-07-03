# frozen_string_literal: true

module Git
  module Cop
    module Reporters
      # Reports issues related to a single cop.
      class Cop
        def initialize cop
          @cop = cop
          @issue = cop.issue
        end

        def to_s
          "  #{severity_label}: #{cop.class.label}. " \
          "#{issue.fetch(:label)} #{issue.fetch(:hint)}\n" \
          "#{affected_lines}"
        end

        private

        attr_reader :cop, :issue

        def severity_label
          cop.severity.to_s.upcase
        end

        def affected_lines
          issue.fetch(:lines, []).reduce("") { |lines, line| lines + Line.new(line).to_s }
        end
      end
    end
  end
end
