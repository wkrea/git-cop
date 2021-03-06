# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitAuthorNameParts < Abstract
        def self.defaults
          {
            enabled: false,
            severity: :warn,
            minimum: 2
          }
        end

        def initialize commit:, settings: self.class.defaults, validator: Validators::Name
          super commit: commit, settings: settings
          @validator = validator
        end

        def valid?
          warn "[DEPRECATION]: Commit Author Name Parts is deprecated, " \
               "use Commit Author Name instead."
          validator.new(commit.author_name, minimum: minimum).valid?
        end

        def issue
          return {} if valid?

          {hint: "Author name must consist of #{minimum} parts (minimum)."}
        end

        private

        attr_reader :validator

        def minimum
          settings.fetch :minimum
        end
      end
    end
  end
end
