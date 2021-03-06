# frozen_string_literal: true

module Git
  module Cop
    module Refinements
      module Strings
        refine String do
          def pluralize count:, suffix: "s"
            return "#{count} #{self}" if count == 1

            "#{count} #{self}#{suffix}"
          end

          def fixup?
            match?(/\Afixup\!\s/)
          end

          def squash?
            match?(/\Asquash\!\s/)
          end
        end
      end
    end
  end
end
