# frozen_string_literal: true

require "refinements/strings"

module Git
  module Cop
    module Styles
      # An abstract class which provides basic functionality from which all style cops inherit from.
      # Not meant for direct use.
      class Abstract
        using ::Refinements::Strings

        LEVELS = %i[warn error].freeze
        ISSUE_LINE_OFFSET = 2

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

        def self.build_issue_line index, line
          {number: index + ISSUE_LINE_OFFSET, content: line}
        end

        attr_reader :commit

        def initialize commit:, settings: self.class.defaults
          @commit = commit
          @settings = settings
          @graylist = load_graylist
        end

        def enabled?
          settings.fetch :enabled
        end

        def severity
          level = settings.fetch :severity
          fail(Errors::Severity, level: level) unless LEVELS.include?(level)
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

        attr_reader :settings, :graylist

        def load_graylist
          Kit::Graylist.new settings[:graylist]
        end
      end
    end
  end
end
