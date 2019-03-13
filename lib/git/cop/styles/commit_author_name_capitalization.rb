# frozen_string_literal: true

module Git
  module Cop
    module Styles
      class CommitAuthorNameCapitalization < Abstract
        def self.defaults
          {
            enabled: false,
            severity: :warn
          }
        end

        def initialize commit:, settings: self.class.defaults, validator: Validators::Capitalization
          super commit: commit, settings: settings
          @validator = validator
        end

        def valid?
          warn "[DEPRECATION]: Commit Author Name Capitalization is deprecated, " \
               "use Commit Author Capitalization instead."
          validator.new(commit.author_name).valid?
        end

        def issue
          return {} if valid?

          {hint: %(Capitalize each part of name: "#{commit.author_name}".)}
        end

        private

        attr_reader :validator
      end
    end
  end
end
