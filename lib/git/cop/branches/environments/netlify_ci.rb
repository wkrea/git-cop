# frozen_string_literal: true

module Git
  module Cop
    module Branches
      module Environments
        # Provides Netlify CI build environment feature branch information.
        class NetlifyCI
          def initialize environment: ENV, repo: Git::Kit::Repo.new
            @environment = environment
            @repo = repo
          end

          def name
            environment["COMMIT_REF"]
          end

          def shas
            repo.shas start: "master", finish: name
          end

          private

          attr_reader :environment, :repo
        end
      end
    end
  end
end
