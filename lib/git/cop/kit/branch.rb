# frozen_string_literal: true

module Git
  module Cop
    module Kit
      class Branch
        REMOTE_PATH = "origin/"

        def initialize
          @path = ENV["CI"] == "true" ? REMOTE_PATH : ""
        end

        def name
          "#{path}#{`git rev-parse --abbrev-ref HEAD | tr -d '\n'`}"
        end

        def shas
          `git log --pretty=format:"%H" #{master}..#{name}`.split("\n")
        end

        private

        attr_reader :path

        def master
          "#{path}master"
        end
      end
    end
  end
end
