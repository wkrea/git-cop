# frozen_string_literal: true

require "open3"

module Git
  module Cop
    module Branches
      module Environments
        # Provides Netlify CI build environment feature branch information.
        class NetlifyCI
          def initialize environment: ENV, shell: Open3
            @environment = environment
            @shell = shell
          end

          def name
            environment["COMMIT_REF"]
          end

          def shas
            shell.capture2e(%(git log --pretty=format:"%H" master..#{name}))
                 .then { |result, _status| result.split "\n" }
          end

          private

          attr_reader :environment, :shell
        end
      end
    end
  end
end
