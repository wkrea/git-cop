# frozen_string_literal: true

require "rake"
require "git/cop"

module Git
  module Cop
    module Rake
      class Tasks
        include ::Rake::DSL

        def self.setup
          new.install
        end

        def initialize cli: CLI
          @cli = cli
        end

        def install
          desc "Run Git Cop"
          task :git_cop do
            cli.start ["--police"]
          end
        end

        private

        attr_reader :cli
      end
    end
  end
end
