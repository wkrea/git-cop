# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitBodyParagraphCapitalization < Abstract
        def self.defaults
          {
            enabled: true,
            severity: :error
          }
        end

        def valid?
          lowercased_lines.empty?
        end

        def issue
          return {} if valid?

          {
            hint: "Capitalize first word.",
            lines: affected_lines
          }
        end

        private

        # :reek:UtilityFunction
        def invalid_line? line
          line.match?(/\A[[:lower:]].+\Z/m)
        end

        def lowercased_lines
          commit.body_paragraphs.select { |line| invalid_line? line }
        end

        def affected_lines
          commit.body_paragraphs.each.with_object([]).with_index do |(line, lines), index|
            lines << {number: index + 1, content: line} if invalid_line?(line)
          end
        end
      end
    end
  end
end
