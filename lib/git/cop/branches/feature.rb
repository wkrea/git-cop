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

        def initialize git_repo: Git::Kit::Repo
          message = "Invalid repository. Are you within a Git-enabled project?"
          fail(Errors::Base, message) unless git_repo.exist?

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
