# frozen_string_literal: true

module Git
  module Cop
    module Commits
      # Represents an existing commit.
      class Saved
        FORMATS = {
          sha: "%H",
          author_name: "%an",
          author_email: "%ae",
          author_date_relative: "%ar",
          subject: "%s",
          body: "%b",
          raw_body: "%B"
        }.freeze

        def self.pattern
          FORMATS.reduce("") { |pattern, (key, value)| pattern + "<#{key}>#{value}</#{key}>%n" }
        end

        def initialize sha:
          @data = `git show --stat --pretty=format:"#{self.class.pattern}" #{sha} 2> /dev/null`
        end

        # :reek:FeatureEnvy
        def == other
          other.is_a?(Saved) && sha == other.sha
        end
        alias eql? ==

        def <=> other
          sha <=> other.sha
        end

        def hash
          sha.hash
        end

        def body_lines
          body.split "\n"
        end

        def fixup?
          subject.match?(/\Afixup\!\s/)
        end

        def squash?
          subject.match?(/\Asquash\!\s/)
        end

        private

        attr_reader :data

        def method_missing name, *arguments, &block
          return super unless FORMATS.keys.include?(name.to_sym)
          String data[%r(\<#{name}\>(?<content>.*?)\<\/#{name}\>)m, :content]
        end

        def respond_to_missing? name, include_private = false
          FORMATS.keys.include?(name.to_sym) || super
        end
      end
    end
  end
end
