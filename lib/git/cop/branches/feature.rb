# frozen_string_literal: true

require "forwardable"

module Git
  module Cop
    module Branches
      # Represents a feature branch.
      class Feature
        extend Forwardable

        def_delegators :environment, :name, :shas

        def self.environment
          if ENV["CIRCLECI"] == "true"
            Environments::CircleCI.new
          elsif ENV["TRAVIS"] == "true"
            Environments::TravisCI.new
          else
            Environments::Local.new
          end
        end

        def initialize
          fail(Errors::Base, "Invalid Git repository.") unless File.exist?(".git")
          @environment = self.class.environment
        end

        def commits
          shas.map { |sha| Commits::Saved.new sha: sha }
        end

        private

        attr_reader :environment
      end
    end
  end
end
