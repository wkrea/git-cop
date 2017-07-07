# frozen_string_literal: true

require "refinements/strings"

module Git
  module Cop
    module Styles
      # An abstract class which provides basic functionality from which all style cops inherit from.
      # Not meant for direct use.
      class Abstract
        using Refinements::Strings

        def self.inherited klass
          @descendants ||= []
          @descendants << klass
        end

        def self.id
          to_s.sub("Git::Cop::Styles", "").snakecase.to_sym
        end

        def self.label
          to_s.sub("Git::Cop::Styles", "").titleize
        end

        def self.defaults
          fail NotImplementedError, "The `.defaults` method has not been implemented."
        end

        def self.descendants
          @descendants || []
        end

        attr_reader :commit

        def initialize commit:, settings: self.class.defaults
          @commit = commit
          @settings = settings
        end

        def enabled?
          settings.fetch :enabled
        end

        def severity
          level = settings.fetch :severity
          fail(Errors::Severity, level: level) unless Errors::Severity::LEVELS.include?(level)
          level
        end

        def valid?
          fail NotImplementedError, "The `#valid?` method has not been implemented."
        end

        def invalid?
          !valid?
        end

        def warning?
          invalid? && severity == :warn
        end

        def error?
          invalid? && severity == :error
        end

        def issue
          fail NotImplementedError, "The `#issue` method has not been implemented."
        end

        protected

        attr_reader :settings
      end
    end
  end
end
