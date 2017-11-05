# frozen_string_literal: true

require "pathname"
require "open3"
require "securerandom"

module Git
  module Cop
    module Commits
      # Represents a partially formed, unsaved commit.
      class Unsaved
        using Refinements::Strings

        SCISSOR_PATTERN = /\#\s\-+\s\>8\s\-+\n.+/m

        attr_reader :raw_body

        def initialize path:, shell: Open3
          @path = Pathname path
          @shell = shell
          @raw_body = File.read path
        rescue Errno::ENOENT
          raise Errors::Base, %(Invalid commit message path: "#{path}".)
        end

        # :reek:UtilityFunction
        def sha
          SecureRandom.hex 20
        end

        def author_name
          result, _status = shell.capture2e "git config --get user.name"
          result.chomp
        end

        def author_email
          result, _status = shell.capture2e "git config --get user.email"
          result.chomp
        end

        def author_date_relative
          "0 seconds ago"
        end

        def subject
          String raw_body.split("\n").first
        end

        # :reek:FeatureEnvy
        def body
          lines = raw_body.sub(SCISSOR_PATTERN, "").split("\n").drop(1)
          computed_body = lines.join("\n")
          lines.empty? ? computed_body : "#{computed_body}\n"
        end

        def body_lines
          body.split("\n").reject { |line| line.start_with?("#") }
        end

        # :reek:FeatureEnvy
        def body_paragraphs
          lines = body.split("\n\n").map { |line| line.sub(/\A\n/, "") }
          lines.map(&:chomp).reject { |line| line.start_with?("#") }
        end

        def == other
          other.is_a?(self.class) && raw_body == other.raw_body
        end
        alias eql? ==

        def <=> other
          raw_body <=> other.raw_body
        end

        def hash
          raw_body.hash
        end

        def fixup?
          subject.fixup?
        end

        def squash?
          subject.squash?
        end

        private

        attr_reader :path, :shell
      end
    end
  end
end
