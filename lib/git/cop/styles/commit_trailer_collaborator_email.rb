# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitTrailerCollaboratorEmail < Abstract
        def self.defaults
          {
            enabled: false,
            severity: :error
          }
        end

        # rubocop:disable Metrics/ParameterLists
        def initialize commit:,
                       settings: self.class.defaults,
                       parser: Parsers::Trailers::Collaborator,
                       validator: Validators::Email

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
            hint: %(Email must follow name and use format: "<name@server.domain>".),
            lines: affected_commit_trailer_lines
          }
        end

        protected

        def invalid_line? line
          collaborator = parser.new line
          collaborator.match? && !validator.new(collaborator.email).valid?
        end

        private

        attr_reader :parser, :validator
      end
    end
  end
end
