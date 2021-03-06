# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitTrailerCollaboratorName < Abstract
        def self.defaults
          {
            enabled: false,
            severity: :error,
            minimum: 2
          }
        end

        # rubocop:disable Metrics/ParameterLists
        def initialize commit:,
                       settings: self.class.defaults,
                       parser: Parsers::Trailers::Collaborator,
                       validator: Validators::Name

          super commit: commit, settings: settings
          @parser = parser
          @validator = validator
        end
        # rubocop:enable Metrics/ParameterLists

        def valid?
          affected_commit_trailer_lines.empty?
        end

        def issue
          return {} if valid?

          {
            hint: "Name must follow key and consist of #{minimum} parts (minimum).",
            lines: affected_commit_trailer_lines
          }
        end

        protected

        def invalid_line? line
          collaborator = parser.new line
          collaborator.match? && !validator.new(collaborator.name.strip, minimum: minimum).valid?
        end

        private

        attr_reader :parser, :validator

        def minimum
          settings.fetch :minimum
        end
      end
    end
  end
end
