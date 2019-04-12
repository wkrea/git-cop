# frozen_string_literal: true

require "forwardable"

module Git
  module Cop
    module Branches
      # Represents a feature branch.
      class Feature
        extend Forwardable

        def_delegators :selected_environment, :name, :shas

        def initialize environment: ENV, git_repo: Git::Kit::Repo
          message = "Invalid repository. Are you within a Git-enabled project?"
          fail Errors::Base, message unless git_repo.exist?

          @current_environment = environment
          @selected_environment = load_environment
        end

        def commits
          shas.map { |sha| Commits::Saved.new sha: sha }
        end

        private

        attr_reader :current_environment, :selected_environment

        def load_environment
          if key? "CIRCLECI" then Environments::CircleCI.new
          elsif netlify? then Environments::NetlifyCI.new environment: current_environment
          elsif key? "TRAVIS" then Environments::TravisCI.new environment: current_environment
          else Environments::Local.new
          end
        end

        def key? key
          current_environment[key] == "true"
        end

        # TODO: Temporary workaround until this pull request is rebased onto `master`:
        # https://github.com/netlify/build-image/pull/297. Once fixed, we'll be able to use
        # `key?("NETLIFY") instead.
        def netlify?
          String(current_environment["DEPLOY_URL"]).include?("netlify")
        end
      end
    end
  end
end
